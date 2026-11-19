# Lesson 14 — Configuration Rollouts, Stale Replicas & Split-Brain Behavior

**Reading/design: 20–25 minutes. Optional practical lab: 45–75 minutes. Status: Published; hands-on unverified.**

**LEARN → DESIGN → BUILD → BREAK → INVESTIGATE → FIX → VALIDATE**

> **Architect challenge:** When an emergency policy changes from allow to deny, what prevents one old API replica from continuing to allow a sensitive action?

This lesson explores **configuration propagation and enforcement**, distinct from [leader election](lesson-09-leader-election-fencing-scheduled-jobs.md), [database migration compatibility](lesson-08-zero-downtime-database-schema-migrations.md), and [HTTP connection pooling](lesson-13-http-connection-pool-head-of-line-blocking.md). The [Networking & Backend Engineering hub](../../networking/index.md) remains the canonical reference for lower-layer network diagnosis.

## LEARN — Production problem

A 24-replica internal maintenance API serves 2,000 requests/second. A central policy document controls a destructive operation. Operations publishes version 418 with \`enabled=false\`, but two replicas still use version 417 with \`enabled=true\`. Their background refresh tasks silently stopped after a schema exception. The load balancer routes requests across both old and new replicas. Customers see intermittent 200 and 403 responses even though the configuration store is healthy.

**Key distinction:** A successful configuration *publish* does not establish that all active replicas *applied* or *enforce* it. Liveness is not policy freshness.

### Functional requirements

1. Operators publish a versioned policy with actor, reason, approval and timestamp.
2. Each response exposes replica ID and applied version; sensitive decisions are auditable.
3. Emergency disable converges within a defined budget; stale replicas must not allow sensitive actions.
4. Non-sensitive read-only endpoints remain observable during store outages.
5. Rollback creates a **new increasing version**, not a decrement.
6. Operators can identify desired version, applied version and last successful refresh independently.

### Nonfunctional requirements

| Dimension | Proposed target | Design implication |
| --- | --- | --- |
| Availability | 99.95% monthly | Avoid remote config reads on every ordinary request |
| Propagation | 99.9% of replicas within 10 seconds | Detect and remediate stragglers |
| Sensitive safety | No allow from policy older than enforced safety floor | Need fail-closed guard or centralized authorization |
| Decision latency | p99 under 20 ms for local policy evaluation | Cache a validated snapshot |
| Audit | 90-day decision and publication history | Correlation IDs, immutable version records |
| Fault isolation | Store outage does not crash all replicas | Last-known-good + explicit age budget |

Targets are illustrative, not measurements. A local freshness TTL **does not guarantee instantaneous revocation**; a replica unaware of a newly published safety floor can still allow until TTL expires. Truly immediate revocation requires a central decision gate, short-lived policy lease, or comparable stronger protocol.

### Capacity and freshness math

Assume 24 replicas, 2,000 requests/sec peak, a 1 KiB document, one update/minute and 2-second polling:

- Per-request store lookup = **2,000 reads/sec** plus store latency on every request.
- Replica polling = **24 / 2 = 12 reads/sec**, roughly 167x fewer reads.
- Healthy polling staleness is ~2 seconds plus jitter and validation. A silently dead refresh task has **unbounded** staleness without a freshness guard.
- For a 10-second convergence SLO, budget 2 seconds polling, 3 seconds network retries, 2 seconds validation and 3 seconds detection/response. These are allocations, not guarantees.
- At 2,000 decisions/sec, naive per-request audit generates 172.8 million events/day. Retain security-critical decisions, sample ordinary reads, and avoid high-cardinality user identifiers in metric labels.
- One stale replica of 24 can affect approximately **4.17%** of evenly distributed traffic; 99.9% *replica convergence* is not the same as 99.9% *request safety*.

## DESIGN — Architecture evolution

### A. Synchronous remote lookup

\`\`\`mermaid
flowchart LR
 Client --> Gateway --> API
 API --> Store[(Policy store)]
 API --> Decision[Allow / deny]
\`\`\`

Every decision reads the store. This reduces local staleness but introduces latency, availability coupling, and a high-QPS store dependency. It may be appropriate for low-volume, high-risk operations.

### B. Local snapshot with background refresh

\`\`\`mermaid
flowchart LR
 Publisher --> Store[(Authoritative versioned document)]
 Store --> A[API A local snapshot]
 Store --> B[API B local snapshot]
 A --> DA[Decision A]
 B --> DB[Decision B]
\`\`\`

This reduces read traffic and allows fast local decisions. But the caches can diverge; an exception or paused worker can leave a process alive while its policy is stale.

### C. Supervised refresh, versioned snapshots, and freshness enforcement

\`\`\`mermaid
flowchart TB
 Operator --> Publisher[Atomic versioned publisher]
 Publisher --> Store[(Authoritative policy)]
 Store --> Monitor[Convergence monitor]
 Store --> A[Replica A: version and age]
 Store --> B[Replica B: version and age]
 Monitor --> Gate[Rollout and traffic gate]
 A --> GA{Fresh enough?}
 B --> GB{Fresh enough?}
 GA -->|yes| PA[Apply policy]
 GA -->|no| DA[Deny sensitive operation]
 GB -->|yes| PB[Apply policy]
 GB -->|no| DB[Deny sensitive operation]
\`\`\`

**Desired version** is committed in the store; **applied version** is loaded and validated by a replica; **freshness** is elapsed monotonic time since a successful refresh; **safety floor** is the minimum version a sensitive decision may use. The floor must be delivered or enforced through a trusted path: stale replicas cannot infer a version they have never seen.

### Architectural trade-offs

| Approach | Advantage | Risk |
| --- | --- | --- |
| Synchronous lookup | Freshness close to source | Store becomes request-path dependency |
| Poll + TTL | Simple and efficient | Delay and refresh task failure |
| Pub/sub + reconciliation | Faster typical propagation | Missed notifications; requires resync |
| Streaming watch | Efficient frequent updates | Persistent connection and reconnect complexity |
| Central authorization gate | Stronger emergency enforcement | Central bottleneck/failure domain |

Choose different failure policies for read-only versus destructive operations. Make readiness reflect *fitness for assigned traffic*, not just process liveness. Publish policy/value/version atomically (e.g. a single JSON record), validate before publication, and never roll back by decreasing the version.

## BREAK — Hypothetical production incident

**All times, metrics, logs and traces below are illustrative, not observed production evidence.**

| UTC | Evidence | Interpretation |
| --- | --- | --- |
| 09:00:00 | Version 418 published, enabled=false | Authoritative update accepted |
| 09:00:06 | 22/24 replicas report 418 | Most refreshers work |
| 09:00:12 | Two replicas still report 417 | Stalled refresh or unreachable store |
| 09:00:18 | HTTP 200 only from old-version replicas | Unsafe decision correlates with stale state |
| 09:01:00 | Uncaught schema exception found in refresher | Background worker exited |
| 09:02:00 | Stale replicas drained | Exposure contained |
| 09:15:00 | Supervised refresh patch tested in canary | Durable repair candidate |

### INVESTIGATE — Chronological, hypothesis-driven evidence

**1. Confirm client-visible symptoms.** Use an authorized production endpoint, not the placeholder below:

\`\`\`bash
for i in $(seq 1 20); do
  curl -sS -i --max-time 2 https://api.example.invalid/sensitive-action |
    grep -Ei 'HTTP/|X-Replica|X-Config-Version'
done
\`\`\`

Expected illustrative correlation: version 417 returns 200; version 418 returns 403. A 200/403 mixture alone does not prove the root cause; correlate with replica/version headers.

**2. Test DNS, TCP and config service separately.**

\`\`\`bash
getent hosts config.internal.example
ss -tnp | grep ':6379' || true
curl -v --connect-timeout 2 --max-time 5 https://config.example.invalid/health
# With authorized Redis credentials and network access:
redis-cli GET policy:current
\`\`\`

Look for resolver differences, refused connections, timeouts, TLS errors, and store version. TCP success does not prove successful refresh or schema parsing. Consult [connection failure diagnosis](../../networking/troubleshooting/connection-failure-diagnosis.md) for the canonical network troubleshooting method.

**3. Compare replicas and refresh task logs.**

\`\`\`bash
kubectl get pods -n platform -l app=policy-api -o wide
kubectl logs -n platform deploy/policy-api --since=20m --all-containers=true |
  grep -E 'refresh|version|exception|stale'
kubectl describe pod -n platform <stale-pod>
\`\`\`

Illustrative structured events:

\`\`\`text
09:00:02 INFO  publish desired_version=418 enabled=false
09:00:03 INFO  refresh replica=api-07 applied_version=418
09:00:04 ERROR refresh replica=api-12 error="invalid policy field"
09:00:20 WARN  decision replica=api-12 applied_version=417 allow=true age_s=79
\`\`\`

Determine whether the worker crashed, schema validation failed, or an old document was deliberately retained. Compare the error timestamp with the last successful refresh.

**4. Separate process health from policy correctness.**

\`\`\`bash
date -u
ps -eo pid,etime,cmd | grep -E 'uvicorn|gunicorn' | head
ss -s
top -b -n 1 | head -20
\`\`\`

Normal CPU, TCP sockets, and HTTP liveness do not prove convergence. Investigate background task supervision and snapshot age.

**5. Reconstruct the control-plane update.**

\`\`\`bash
redis-cli GET policy:current
# For a hash-based production design, inspect all fields together:
redis-cli HGETALL policy:current
\`\`\`

Check atomicity of version/value updates, publication validation, and whether a writer accidentally mixed schema versions. Do not print secrets into incident logs.

**6. Correlate telemetry.** Trace attributes: \`replica.id\`, \`config.version\`, \`config.age_ms\`, \`decision\`, and request ID. Metrics: \`config_applied_version{replica}\`, \`config_last_refresh_timestamp_seconds{replica}\`, \`config_refresh_errors_total{reason}\`, \`config_convergence_lag_seconds\`, \`sensitive_decisions_total{decision,version}\`. Never use user IDs as metric labels.

### Root cause and systemic weakness

- **Trigger:** an unexpected config field causes schema validation failure.
- **Immediate cause:** refresh coroutine exits without retry; an old allow snapshot remains active.
- **Systemic weakness:** no freshness guard, convergence alert, or traffic drain for stale replicas; process liveness was mistaken for decision correctness.
- **Unproven alternatives:** Redis outage, DNS failure, or gateway fault. The evidence does not establish them.

## FIX — Mitigation, redesign and validation

**Immediate:** disable sensitive action centrally if possible; otherwise remove stale replicas from the sensitive traffic pool, verify remaining replicas deny, and preserve logs. Restarting a stale replica may help but is not a durable solution.

**Long-term:** schema validation before publish, atomic versioned documents, supervised refresh with bounded backoff/jitter, last-success timestamps, age-based fail-closed decisions, convergence metrics, rollout gates, immutable audit and rollback as a new version. For immediate revocation, add a centralized safety barrier or short-lived lease.

**Validation:** normal convergence across all replicas; one stopped refresher becomes deny after age budget; store outage keeps read-only health available; malformed publication rejected; monotonic rollback; restart; alert on stale serving replicas. Alert on \`now-last_refresh > 10s\` or desired/applied divergence exceeding 10s, and assess actual exposed request volume.

## Architect challenges — answer independently

1. **Safety vs availability:** Redis is unavailable for 60 seconds. Which endpoints can serve last-known-good state, and which must deny? Justify business and security impact.
2. **Convergence at scale:** For 2,000 replicas across three regions with 5-second convergence, compare polling, pub/sub with reconciliation, and streaming watch. Estimate read QPS and failure modes.
3. **Rollback correctness:** Version 418 disables an action; version 419 restores it. How will you audit the rollback and prevent version 417 from being accepted as current?

---

## Practical Labs

**Optional hands-on: 45–75 minutes, separate from reading.** Use **Mac M4 Docker Desktop** (preferred) or Ubuntu Docker Engine with Compose plugin. Reserve ~1 GiB free RAM; a 1-CPU/1.9-GiB VM may be slow. We use Redis because this is configuration propagation, not relational transactions; no PostgreSQL is necessary. All services are open source: NGINX, FastAPI, Redis.

### BUILD — Prerequisites and files

Verify \`docker version\` and \`docker compose version\`, then create an isolated directory:

\`\`\`bash
mkdir -p ~/architecture-lab14/app ~/architecture-lab14/nginx
cd ~/architecture-lab14
\`\`\`

\`\`\`text
architecture-lab14/
├── compose.yaml
├── Dockerfile
├── requirements.txt
├── app/
│   ├── main.py
│   └── test_policy.py
└── nginx/
    └── default.conf
\`\`\`

For every file, run \`cat > FILE <<'EOF'\`, paste the corresponding block, then type \`EOF\`. Keep all files in this directory.

**File: \`requirements.txt\`**

\`\`\`text
fastapi==0.115.12
uvicorn==0.34.2
redis==5.2.1
httpx==0.28.1
pytest==8.3.5
\`\`\`

**File: \`Dockerfile\`**

\`\`\`dockerfile
FROM python:3.12-slim
WORKDIR /code
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app/ /code/app/
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
\`\`\`

**File: \`compose.yaml\`**

\`\`\`yaml
name: architecture-lab14
services:
  redis:
    image: redis:7-alpine
    command: ["redis-server", "--appendonly", "no"]
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 2s
      timeout: 2s
      retries: 15
  api-a:
    build: .
    environment:
      REPLICA: api-a
      REDIS_URL: redis://redis:6379/0
      MAX_AGE_SECONDS: "5"
    depends_on:
      redis:
        condition: service_healthy
  api-b:
    build: .
    environment:
      REPLICA: api-b
      REDIS_URL: redis://redis:6379/0
      MAX_AGE_SECONDS: "5"
    depends_on:
      redis:
        condition: service_healthy
  gateway:
    image: nginx:1.27-alpine
    ports:
      - "127.0.0.1:8094:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - api-a
      - api-b
\`\`\`

**File: \`nginx/default.conf\`**

\`\`\`nginx
upstream policy_api {
    server api-a:8000;
    server api-b:8000;
}
server {
    listen 80;
    location / {
        proxy_pass http://policy_api;
        proxy_set_header Host $host;
        proxy_connect_timeout 2s;
        proxy_read_timeout 5s;
    }
}
\`\`\`

**File: \`app/main.py\`**

\`\`\`python
import asyncio
import json
import logging
import os
import time
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException, Response
from redis.asyncio import Redis

logging.basicConfig(level=logging.INFO)
log = logging.getLogger("policy")
REPLICA = os.getenv("REPLICA", "local")
MAX_AGE = float(os.getenv("MAX_AGE_SECONDS", "5"))
redis = Redis.from_url(os.getenv("REDIS_URL", "redis://redis:6379/0"), decode_responses=True)
state = {"version": 0, "enabled": False, "refreshed": 0.0, "paused": False, "errors": 0}


async def refresh_once():
    raw = await redis.get("policy:current")
    if raw is None:
        return
    doc = json.loads(raw)
    version = int(doc["version"])
    enabled = doc["enabled"]
    if type(enabled) is not bool:
        raise ValueError("enabled must be boolean")
    if version < state["version"]:
        raise ValueError("version regression")
    state.update(version=version, enabled=enabled, refreshed=time.monotonic())
    log.info("refresh replica=%s version=%s enabled=%s", REPLICA, version, enabled)


async def refresh_loop():
    while True:
        try:
            if not state["paused"]:
                await refresh_once()
        except Exception:
            state["errors"] += 1
            log.exception("refresh failed replica=%s", REPLICA)
        await asyncio.sleep(1)


@asynccontextmanager
async def lifespan(app: FastAPI):
    task = asyncio.create_task(refresh_loop())
    try:
        yield
    finally:
        task.cancel()
        try:
            await task
        except asyncio.CancelledError:
            pass
        await redis.aclose()


app = FastAPI(lifespan=lifespan)


def snapshot():
    age = time.monotonic() - state["refreshed"] if state["refreshed"] else None
    return {"replica": REPLICA, "version": state["version"],
            "enabled": state["enabled"],
            "age_seconds": round(age, 2) if age is not None else None,
            "fresh": age is not None and age <= MAX_AGE,
            "refresh_errors": state["errors"]}


@app.get("/health")
async def health():
    return {"status": "up", **snapshot()}


@app.post("/sensitive-action")
async def action(response: Response):
    s = snapshot()
    headers = {"X-Replica": REPLICA, "X-Config-Version": str(s["version"])}
    if not s["fresh"]:
        raise HTTPException(503, detail={"reason": "stale policy", **s}, headers=headers)
    if not s["enabled"]:
        raise HTTPException(403, detail={"reason": "disabled", **s}, headers=headers)
    response.headers.update(headers)
    return {"decision": "allowed", **s}


@app.post("/lab/pause")
async def pause():
    state["paused"] = True
    return {"replica": REPLICA, "paused": True}


@app.post("/lab/resume")
async def resume():
    state["paused"] = False
    await refresh_once()
    return {"replica": REPLICA, "paused": False}
\`\`\`

**File: \`app/test_policy.py\`**

\`\`\`python
import time
from app import main


def test_stale_snapshot_denied():
    old = main.state.copy()
    try:
        main.state.update(version=1, enabled=True, refreshed=time.monotonic() - 100)
        assert main.snapshot()["fresh"] is False
    finally:
        main.state.update(old)


def test_fresh_snapshot():
    old = main.state.copy()
    try:
        main.state.update(version=2, enabled=False, refreshed=time.monotonic())
        assert main.snapshot()["fresh"] is True
    finally:
        main.state.update(old)
\`\`\`

The \`/lab/*\` endpoints are **intentionally unauthenticated fault-injection controls** and must never be deployed in production. The gateway binds to localhost only; the Redis container has no published port or persistent volume.

### Healthy startup and baseline

\`\`\`bash
cd ~/architecture-lab14
docker compose up -d --build
docker compose ps
docker compose exec -T redis redis-cli SET policy:current '{"version":1,"enabled":true}'
sleep 3
curl -sS http://127.0.0.1:8094/health
for i in 1 2 3 4; do
  curl -sS -i -X POST http://127.0.0.1:8094/sensitive-action |
    grep -Ei 'HTTP/|X-Replica|X-Config-Version'
done
\`\`\`

**Expected:** version 1, \`fresh=true\`, HTTP 200 from both replicas. A 503 immediately at startup may mean the first refresh has not completed; a 502 requires checking \`docker compose logs gateway api-a api-b\`.

### BREAK — One controlled, reversible failure

Pause **only replica B's refresher**, then publish emergency deny:

\`\`\`bash
docker compose exec -T api-b python -c \
  "import urllib.request; print(urllib.request.urlopen(urllib.request.Request('http://127.0.0.1:8000/lab/pause',data=b'',method='POST')).read().decode())"
docker compose exec -T redis redis-cli SET policy:current '{"version":2,"enabled":false}'
sleep 7
for i in 1 2 3 4 5 6; do
  curl -sS -i -X POST http://127.0.0.1:8094/sensitive-action |
    grep -Ei 'HTTP/|X-Replica|X-Config-Version'
done
\`\`\`

**Expected:** A returns **403, version 2**; B returns **503, version 1** because its cache age exceeds five seconds. The freshness guard prevents stale B from returning unsafe 200. A deliberately broken design without the guard would return 200. This simulates stalled refresh, not a real schema-crash injection.

### INVESTIGATE — Collect evidence before fixing

\`\`\`bash
docker compose logs --tail=40 api-a api-b
docker compose exec -T redis redis-cli GET policy:current
docker compose exec -T api-a python -c \
  "import urllib.request; print(urllib.request.urlopen('http://127.0.0.1:8000/health').read().decode())"
docker compose exec -T api-b python -c \
  "import urllib.request; print(urllib.request.urlopen('http://127.0.0.1:8000/health').read().decode())"
docker compose exec -T api-b python -c \
  "import socket; print(socket.gethostbyname('redis')); s=socket.create_connection(('redis',6379),2); print('TCP OK'); s.close()"
\`\`\`

**Interpretation:** Redis holds version 2, A applied version 2, B retains version 1 and reports \`fresh=false\`. DNS and TCP connectivity from B are healthy, so do not misdiagnose this as a network partition. Compare authoritative and applied state.

### FIX — Resume B, then roll back with a new version

\`\`\`bash
docker compose exec -T api-b python -c \
  "import urllib.request; print(urllib.request.urlopen(urllib.request.Request('http://127.0.0.1:8000/lab/resume',data=b'',method='POST')).read().decode())"
sleep 2
for i in 1 2 3 4; do
  curl -sS -i -X POST http://127.0.0.1:8094/sensitive-action |
    grep -Ei 'HTTP/|X-Replica|X-Config-Version'
done
# Expected: both 403, version 2.
docker compose exec -T redis redis-cli SET policy:current '{"version":3,"enabled":true}'
sleep 2
\`\`\`

Rollback is **version 3**, not a regression to version 1. In a real system, publication must be authenticated, validated and audited.

### VALIDATE — Automated tests and end-to-end state

\`\`\`bash
docker compose exec -T api-a python -m pytest -q app/test_policy.py
docker compose exec -T api-b python -m pytest -q app/test_policy.py
for i in 1 2 3 4; do
  curl -sS -i -X POST http://127.0.0.1:8094/sensitive-action |
    grep -Ei 'HTTP/|X-Replica|X-Config-Version'
done
\`\`\`

**Expected:** two tests pass per replica; both replicas now return 200 with version 3. These are local tests of freshness and convergence, not proof of global consistency or production security.

### Safe cleanup

\`\`\`bash
cd ~/architecture-lab14
docker compose down
\`\`\`

This removes only the Compose project's containers and network. **Do not use** \`docker compose down -v\`, \`docker volume prune\` or \`docker system prune\`; preserve unrelated named volumes. Keep source files for future practice.

**Execution method:** perform one step, record and share actual output, explain what it proves, and only then introduce the next fault. No local execution is claimed by this publication.

---

## My Architecture Review — Solutions & Doubts

### 1. My Understanding

_Explain desired versus applied version and policy freshness._

### 2. My Solutions to the Architect Challenges

_Challenge 1 — safety vs availability:_

_Challenge 2 — multi-region convergence:_

_Challenge 3 — monotonic rollback:_

### 3. My Troubleshooting Approach

_Which evidence disproves a network problem?_

### 4. My Proposed Architecture Improvements

_Describe refresh supervision, traffic admission, and safety enforcement._

### 5. My Doubts / Questions

_Questions about consistency, failover or operational constraints._

### 6. Lessons Learned

_Record actual observations only after hands-on execution._

### 7. Mentor Review

_Pending reasoning-focused review of your answers, evidence and trade-offs._
