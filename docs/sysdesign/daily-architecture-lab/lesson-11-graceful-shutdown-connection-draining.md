# Daily Architecture Incident Lab — Lesson 11: Graceful Shutdown, Connection Draining & Zero-Downtime Deployments

**Published:** 2026-11-16 · **Status:** Published (not completed) · **Architecture reading/design:** 20–25 minutes · **Optional local hands-on:** 60–90 minutes

**LEARN → DESIGN → BUILD → BREAK → INVESTIGATE → FIX → VALIDATE**

> **Scenario disclosure:** All companies, incidents, timestamps, request rates, log lines, measurements, and traces in this lesson are **hypothetical training examples**, not observations from IBM or any real environment. Local commands produce actual observations only after you run them. Do not practice termination against production.

## Learning objectives and 25-minute plan

By the end, explain why a healthy replacement instance does not guarantee a zero-error deployment; calculate drain and shutdown budgets; distinguish readiness, liveness, termination grace, upstream keep-alive, and in-flight requests; and design observable, testable termination behavior.

| Minutes | Activity |
|---|---|
| 0–4 | Requirements and request lifecycle |
| 4–8 | Capacity and drain-time calculations |
| 8–12 | Incremental architectures and tradeoffs |
| 12–19 | Hypothetical incident investigation |
| 19–22 | Mitigation, durable redesign and validation |
| 22–25 | Three independent architect challenges |

## 1. LEARN — Realistic problem and requirements

A platform team runs an **Incident Summary API** behind an NGINX ingress or cloud load balancer. During a deployment, old API instances receive SIGTERM while some requests are performing an expensive but legitimate 4-second incident summary. New instances become ready quickly. The rollout is marked successful, yet users see occasional 502s, 503s and connection resets.

**Functional requirements:** authenticated users retrieve incident summaries; a request admitted before drain should complete within its contract deadline; new requests go to ready instances; deployments do not duplicate non-idempotent effects; health endpoints expose distinct *alive* and *ready* meanings; requests carry a correlation ID.

**Nonfunctional requirements (hypothetical design targets):**

| Dimension | Target |
|---|---|
| Peak traffic | 600 RPS |
| Normal p95 / p99 | 150 ms / 2 s |
| Legitimate slow operation | 4 s; request deadline 6 s |
| API availability | 99.95% monthly |
| Deployment-induced errors | Target zero; alert on any sustained increase |
| Replicas | 6, each sustainable at 150 RPS |
| Load balancer removal propagation | p99 up to 3 s |
| Container shutdown grace | 12 s |
| Gateway upstream timeout | 6 s |
| In-flight completion | Bounded by admission stop + max request deadline |

**Failure contract:** A request admitted before drain may finish; new requests after drain begins should be routed elsewhere, or receive a deliberate 503 with Retry-After if a stale gateway still sends traffic. Do not pretend that terminating a process guarantees exactly-once effects for writes. A graceful shutdown protects availability; idempotency protects retried side effects.

## 2. DESIGN — Quantify before selecting settings

**Capacity:** 600 RPS across six replicas means 100 RPS each. If one replica is removed, five at 150 RPS each provide 750 RPS, a 25% margin above current traffic. If two are removed, four provide 600 RPS, **no spare capacity** for spikes. A rollout with maxUnavailable=1 and maxSurge=1 can preserve headroom if the new pod is truly ready before an old one drains.

**In-flight requests:** Little's Law, L = λW. At 100 RPS and mean 0.12 s, ~12 requests are in flight per replica. If a tail of slow 4-second requests dominates, demand may approach 400 concurrent requests for that replica at 100 RPS. This is an illustrative bound, not a forecast; real concurrency depends on request mix, arrival distribution and admission controls.

**Termination budget:**

~~~text
readiness change / endpoint propagation     3.0 s (p99)
maximum admitted request deadline            6.0 s
process cleanup / telemetry flush            1.0 s
scheduling and signal margin                 2.0 s
----------------------------------------------------
recommended grace budget                    12.0 s
~~~

This is conservative when draining stops new admission immediately; the 3 seconds covers stale upstream routing and coordination. If requests can be admitted throughout propagation, a 6-second request started at t=3 requires until t=9. A 5-second termination grace would be mathematically insufficient. Ensure load balancer idle/keepalive reuse and downstream calls fit the same end-to-end deadline.

**Availability budget:** 99.95% of a 30-day month permits 0.0005 × 30 × 24 × 60 = **21.6 minutes** of equivalent unavailability. A 1% error rate during ten 2-minute daily rollouts is not zero; measure user-visible error fraction, not only uptime or deployment success.

## 3. Incremental architecture and failure domains

### Version A — unsafe: replace the process immediately

~~~mermaid
flowchart LR
  C[Client] --> G[NGINX gateway]
  G --> A[Old FastAPI process]
  A --> W[Slow 4-second request]
  K[Deployment controller] -->|SIGTERM then immediate exit| A
~~~

The old process exits while NGINX still has an upstream socket or a request in flight. The gateway may emit 502 (reset/premature close) or 504 (upstream deadline), while new replicas appear healthy. These statuses identify **where** the failure surfaced, not necessarily the root cause.

### Version B — coordinated draining

~~~mermaid
sequenceDiagram
  participant C as Client
  participant G as Gateway
  participant K as Controller
  participant A as Old API
  participant N as New API
  K->>N: Start and verify readiness
  K->>A: Begin drain / readiness=false
  A-->>K: No new admission
  Note over G,A: Endpoint removal propagation
  G->>N: Route new requests
  A->>A: Finish admitted in-flight requests
  K->>A: SIGTERM after drain window
  A-->>K: Exit after bounded cleanup
  C->>G: Next request
  G->>N: Serve from ready replacement
~~~

**Design invariants:** (1) New capacity is ready before old capacity leaves. (2) Draining instances stop accepting new work. (3) Endpoint removal is observed, not merely assumed. (4) Old requests have finite deadlines. (5) Shutdown timeout exceeds the longest legitimate remaining work plus margin. (6) Observability identifies termination phase and active requests.

### Version C — production-ready layered controls

~~~mermaid
flowchart LR
  C[Clients] --> LB[Load balancer / ingress]
  LB --> S[Service endpoint set]
  S --> R1[Ready API replicas]
  S -.remove endpoint.-> R2[Draining API replica]
  R2 --> A[Active request tracker]
  A --> D[Bounded dependency calls]
  M[Metrics and traces] -.observe.-> LB
  M -.observe.-> R2
  K[Rollout controller] --> S
  K --> R2
~~~

**Alternatives and tradeoffs:**

| Choice | Benefit | Cost / caveat |
|---|---|---|
| preStop delay only | Easy endpoint-propagation buffer | Delay consumes grace; not enough if app exits on SIGTERM |
| App-level drain endpoint | Explicit admission and in-flight tracking | Must secure endpoint and coordinate with controller |
| SIGTERM handler + server graceful timeout | Fits process lifecycle | Different ASGI servers and worker counts behave differently |
| Ingress retries | May mask safe GET failures | Can amplify traffic; unsafe for non-idempotent POST without keys |
| Connection draining at LB | Avoids new assignments to retiring backend | Existing HTTP/2 streams and persistent connections need explicit policies |
| Blue/green | Strong traffic switch and rollback | Double capacity and state compatibility |
| Rolling update | Resource efficient | Requires careful readiness, surge, termination and capacity budgeting |

**Kubernetes interpretation:** Readiness false removes an endpoint eventually; it does not immediately close existing sockets. A preStop hook consumes termination grace. SIGTERM delivery, EndpointSlice updates, ingress synchronization, application drain and kubelet SIGKILL must be budgeted together. Never make liveness fail merely because the pod is draining; liveness is for restarting unhealthy processes, not endpoint selection.

## 4. Hypothetical production incident: 09:00–09:22 UTC

**Hypothetical trigger:** A routine six-replica rollout replaces two pods concurrently. Old pods receive SIGTERM and exit in 200 ms. Each has active 4-second requests. Endpoint removal takes 2.5 seconds to reach an ingress replica. Some upstream sockets are reused during that window.

| Time UTC | Evidence | Interpretation and next check |
|---|---|---|
| 09:00 | Rollout starts; two old pods terminating | Compare rollout policy with spare capacity |
| 09:01 | 502 rate rises to 2.4%; new pods ready | New readiness alone does not prove old requests completed |
| 09:02 | Ingress: upstream prematurely closed connection | Correlate upstream pod and termination timestamp |
| 09:03 | Old pod logs SIGTERM with 27 active requests | Likely in-flight interruption |
| 09:05 | 5 remaining/ready pods; CPU 48%; DB healthy | Saturation not proven; investigate lifecycle |
| 09:08 | Trace ends at Summary API during a 4-second operation | Request interrupted at process termination |
| 09:11 | Rollout paused; 502 rate returns to baseline | Strong association, not final proof |
| 09:16 | Canary with drain delay and grace=12 s | Compare old pod active requests and error rate |
| 09:22 | Canary requests complete, no observed rollout 502 | Supports mitigation; keep monitoring |

### 4.1 Establish blast radius and correlate the timeline

On an authorized Kubernetes workstation:

~~~bash
kubectl -n incident-platform get deploy,rs,pods -o wide
kubectl -n incident-platform rollout history deploy/summary-api
kubectl -n incident-platform describe deploy summary-api
kubectl -n incident-platform get events --sort-by=.lastTimestamp | tail -n 30
kubectl -n incident-platform get endpointslice -l kubernetes.io/service-name=summary-api -o yaml
~~~

**Expected hypothetical evidence:** pod termination events align with gateway errors; EndpointSlice shows terminating/not-ready endpoints while ingress may lag. If no Kubernetes access, inspect cloud deployment revision events and instance lifecycle timestamps instead.

### 4.2 Inspect ingress and network symptoms

~~~bash
# On an authorized ingress host or container, adapt paths to your platform:
grep -E 'upstream prematurely closed|upstream timed out|connect\(\) failed' /var/log/nginx/error.log | tail -n 30
ss -tan state established '( sport = :8000 or dport = :8000 )' | head
curl -sS -o /dev/null -w 'status=%{http_code} total=%{time_total}s\n' --max-time 7 https://summary.example.internal/summary/INC-2048
~~~

**Illustrative NGINX error:** \`upstream prematurely closed connection while reading response header from upstream\`. This often maps to 502, but may also reflect application crashes, OOM, proxy bugs or network resets. Confirm with process logs before assigning cause. A 504 near the gateway timeout points to a different symptom.

### 4.3 Application, signal and dependency evidence

~~~bash
kubectl -n incident-platform logs summary-api-old-xyz --previous --timestamps | tail -n 60
kubectl -n incident-platform describe pod summary-api-old-xyz
kubectl -n incident-platform top pods
# On a Linux host:
ps -eo pid,ppid,stat,etime,cmd | grep -E 'uvicorn|gunicorn'
journalctl -u summary-api --since '2026-11-16 09:00:00 UTC' --no-pager | tail -n 50
~~~

**Illustrative app logs:**

~~~text
09:01:01.120 request_id=ab12 event=request_started path=/summary/INC-2048 active=27
09:01:01.204 event=sigterm_received active=27 drain=false
09:01:01.410 event=process_exit active=27
~~~

**Illustrative trace:** gateway span 0.21 s → Summary API span aborted → downstream DB span was healthy. This supports interruption by process exit, not a slow SQL query. If app logs show OOMKilled or a crash instead, revise the hypothesis.

### 4.4 Database and infrastructure elimination

~~~sql
SELECT state, wait_event_type, wait_event, count(*) AS sessions
FROM pg_stat_activity GROUP BY 1,2,3 ORDER BY sessions DESC;
SELECT now()-query_start AS running_for, wait_event_type, left(query,100)
FROM pg_stat_activity WHERE state='active' ORDER BY query_start LIMIT 10;
~~~

**Hypothetical metric comparison:** gateway 502 2.4%; pod restarts 0; termination active requests 27; DB checkout wait p95 8 ms; PostgreSQL CPU 34%; endpoint propagation p99 2.5 s. Low DB wait does not prove no database issue, but combined lifecycle evidence prioritizes termination handling.

**Evidence hierarchy:** request ID → ingress upstream address and status → pod lifecycle → app active-request counter → trace and DB timings → reproduce in canary. Do not increase NGINX timeout as a reflex: a killed process cannot finish regardless of timeout.

## 5. Root cause versus systemic weakness

- **Trigger:** A routine rollout terminates two old instances while requests are in flight.
- **Immediate cause:** Old API processes exit before their admitted requests finish; ingress can still send traffic briefly to retiring endpoints.
- **Systemic weakness:** No coordinated drain state, inadequate termination grace, no active-request tracking, insufficient rollout surge policy, and missing deployment-specific error monitoring.
- **Contributing risks:** Keep-alive connection reuse, uneven request distribution, slow downstream calls, retry amplification and missing idempotency keys.

A rollback may stop further damage, but does not repair lifecycle correctness. Likewise, adding replicas alone cannot guarantee existing requests finish.

## 6. Mitigation and long-term redesign

**Immediate (incident commander):** pause rollout; confirm new capacity and service health; reduce maxUnavailable to 1 or 0 where surge permits; roll back if errors persist; avoid repeated blind retries; announce the risk to users. Do not forcibly kill a pod to accelerate rollout.

**Durable design:** implement an authenticated drain transition that flips readiness and rejects new admissions; wait for endpoint removal propagation; let existing requests finish under a bounded deadline; give the server enough termination grace; set explicit dependency timeouts; instrument drain state, active requests, process exits, ingress upstream errors, and per-revision request success. For Kubernetes, verify the exact semantics of the ingress controller, ASGI server and deployment platform in use.

**Deployment policy example (conceptual):**

~~~yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
template:
  spec:
    terminationGracePeriodSeconds: 12
    containers:
      - name: api
        readinessProbe:
          httpGet: {path: /ready, port: 8000}
          periodSeconds: 2
        livenessProbe:
          httpGet: {path: /live, port: 8000}
          periodSeconds: 5
~~~

This is an excerpt, not a complete Kubernetes Deployment. **Important:** setting readiness false alone does not orchestrate SIGTERM; implement a drain hook/controller sequence and test propagation. Avoid making a preStop sleep so long that no time remains for active requests.

## 7. Observability and operational validation

| Signal | Example metric/log | Why it matters |
|---|---|---|
| Drain transition | \`api_draining{revision}\` | Prove old instance stopped admitting |
| Active requests | \`api_inflight_requests{revision}\` | Know when safe to terminate |
| Termination age | \`api_shutdown_seconds\` | Compare with grace budget |
| Gateway upstream failures | \`nginx_upstream_502_total\` | Detect client-visible errors |
| Endpoint propagation | time from ready=false to removal | Quantify LB lag |
| Request deadline | \`http_server_duration_seconds\` histogram | Set bounded drain time |
| DB/Redis latency | pool checkout and dependency histograms | Exclude other bottlenecks |
| Revision comparison | 5xx and p99 by old/new revision | Distinguish deployment regression |

**Validation gates:** no requests accepted after drain; requests already admitted finish; process exits before grace expires; ingress stops routing to drained instance; all tests pass after rollback; no unexpected 502 during repeated canary rollouts; metrics preserve revision labels. Run multiple trials—one clean rollout is insufficient proof.

## 8. Three independent architect challenges

1. **Capacity and safety:** At 600 RPS, six replicas each support 150 RPS. A rollout removes two replicas simultaneously and one new replica is ready. Calculate the available capacity and margin; propose maxSurge/maxUnavailable settings and justify cost.
2. **Deadline reasoning:** Endpoint removal p99=3 s, admitted request deadline=6 s, cleanup=1 s and safety=2 s. Is 8 s termination grace sufficient? Explain the race with stale gateway routing and derive a defensible value.
3. **Operational decision:** During a canary, readiness turns false and gateway 502s still rise, while DB metrics remain healthy. List three competing hypotheses and the minimum evidence needed to distinguish them. Propose one mitigation and one long-term architectural fix.

Do not copy a canned answer. Record your assumptions, calculations, tradeoffs and falsifiable evidence in the final review.

## 9. References and related learning

- [Kubernetes Pod termination lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-termination)
- [Kubernetes Deployment rolling updates](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment)
- [NGINX proxy module timeouts](https://nginx.org/en/docs/http/ngx_http_proxy_module.html)
- [Uvicorn deployment and graceful shutdown](https://www.uvicorn.org/server-behavior/)
- Earlier Wiki: [Lesson 05 — API Gateway cascading failures](lesson-05-api-gateway-cascading-failures-circuit-breakers.md) and [Lesson 09 — Leader election and fencing](lesson-09-leader-election-fencing-scheduled-jobs.md). This lesson focuses on **process lifecycle**, not dependency circuit breakers or scheduler ownership.

## Practical Labs

**Optional hands-on: 60–90 minutes in addition to the 20–25-minute reading/design.** This builds the **same gateway → Incident Summary API → slow request** path, then demonstrates unsafe termination versus coordinated draining. Use **Mac Docker Desktop** (recommended: 2 CPUs, ~1 GB free RAM, 1 GB free disk). Ubuntu VM alternative: Docker Engine and Compose plugin; use \`sudo docker\` if your user lacks Docker group access. No database is needed: this failure is specifically a process-lifecycle failure, not a persistence failure. Do not add PostgreSQL merely for decoration.

**Safety:** Docker Compose project \`archlab11\`, localhost-only port 18011, no external traffic, no secrets, no unrelated volume deletion. A deliberate 502 may occur; that is expected only inside this lab.

### LEARN / DESIGN — Local architecture and expected request

~~~mermaid
flowchart LR
  C[curl] --> G[NGINX :18011]
  G --> A[FastAPI :8000]
  A --> S[Simulated slow incident summary: 4 seconds]
  H[Host terminal] -->|SIGTERM| A
  H -->|drain request| A
~~~

**Behavior:** Healthy \`GET /summary/INC-2048?delay=4\` returns 200 after four seconds. Unsafe SIGTERM during that request interrupts it. In protected mode, \`POST /admin/drain\` marks readiness false and prevents new work while the existing request completes; only then terminate. This is an explicit **local two-phase drain protocol**, not an assertion that Compose implements Kubernetes EndpointSlice propagation.

### BUILD — Prerequisites, directory tree and exact file creation

On Mac Terminal or Ubuntu shell:

~~~bash
docker version
docker compose version
mkdir -p ~/architecture-labs/lesson11-draining/{app,nginx,tests}
cd ~/architecture-labs/lesson11-draining
touch app/__init__.py
pwd
~~~

Directory:

~~~text
lesson11-draining/
├── app/
│   ├── __init__.py
│   └── main.py
├── nginx/
│   └── default.conf
├── tests/
│   └── test_app.py
├── Dockerfile
├── requirements.txt
└── compose.yaml
~~~

Create each file using your editor (\`nano\`, VS Code, or \`cat > filename <<'EOF'\` followed by the corresponding code and \`EOF\`). All content is embedded below.

**File: \`requirements.txt\`**

~~~text
fastapi==0.115.12
uvicorn==0.34.2
httpx==0.28.1
pytest==8.3.5
~~~

**File: \`app/main.py\`**

~~~python
import asyncio
import logging
import os
import signal
import time
from contextlib import asynccontextmanager
from fastapi import FastAPI, HTTPException, Request

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(message)s")
log = logging.getLogger("drainlab")
draining = False
active = 0
completed = 0
started = 0
lock = asyncio.Lock()

@asynccontextmanager
async def lifespan(app: FastAPI):
    log.info("startup pid=%s", os.getpid())
    yield
    log.info("shutdown pid=%s active=%s", os.getpid(), active)

app = FastAPI(lifespan=lifespan)

@app.get("/live")
async def live():
    return {"alive": True}

@app.get("/ready")
async def ready():
    if draining:
        raise HTTPException(503, "draining")
    return {"ready": True}

@app.get("/metrics")
async def metrics():
    return {"draining": draining, "active": active,
            "started": started, "completed": completed}

@app.post("/admin/drain")
async def drain(request: Request):
    global draining
    # Lab-only endpoint: service is not published directly to host.
    # A real endpoint MUST require strong authorization.
    draining = True
    log.info("drain_started active=%s", active)
    return {"draining": True, "active": active}

@app.get("/summary/{incident_id}")
async def summary(incident_id: str, delay: float = 0.1):
    global active, started, completed
    if not 0 <= delay <= 5:
        raise HTTPException(422, "delay must be between 0 and 5")
    async with lock:
        if draining:
            log.warning("request_rejected incident=%s draining=true", incident_id)
            raise HTTPException(503, "instance draining")
        active += 1
        started += 1
    try:
        log.info("request_started incident=%s active=%s", incident_id, active)
        await asyncio.sleep(delay)
        completed += 1
        log.info("request_completed incident=%s active=%s", incident_id, active)
        return {"incident_id": incident_id, "status": "investigating",
                "severity": 2, "duration_s": delay}
    finally:
        async with lock:
            active -= 1
~~~

**Important implementation note:** This intentionally minimal FastAPI app exposes a drain endpoint through NGINX unless blocked. The NGINX config below blocks \`/admin/\` from the host; use \`docker compose exec api\` for admin calls. Metrics are process-local and reset on restart. Uvicorn's graceful SIGTERM behavior is configurable; to make the **unsafe** failure deterministic, we explicitly use SIGKILL for the first demonstration, and then compare with coordinated draining. A SIGKILL is a simulation of an immediate crash, not a claim that every SIGTERM is unsafe.

**File: \`nginx/default.conf\`**

~~~nginx
log_format lab '$time_iso8601 status=$status upstream=$upstream_addr '
               'request_time=$request_time upstream_time=$upstream_response_time';
server {
    listen 80;
    access_log /var/log/nginx/access.log lab;
    location /admin/ { return 403; }
    location / {
        proxy_pass http://api:8000;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_connect_timeout 1s;
        proxy_read_timeout 6s;
    }
}
~~~

**File: \`Dockerfile\`**

~~~dockerfile
FROM python:3.11-slim
WORKDIR /code
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app ./app
COPY tests ./tests
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--timeout-graceful-shutdown", "10"]
~~~

**File: \`compose.yaml\`**

~~~yaml
services:
  gateway:
    image: nginx:1.27-alpine
    ports:
      - "127.0.0.1:18011:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - api
  api:
    build: .
    stop_grace_period: 12s
~~~

**File: \`tests/test_app.py\`**

~~~python
from fastapi.testclient import TestClient
from app.main import app

def test_live_and_ready():
    with TestClient(app) as client:
        assert client.get("/live").status_code == 200
        assert client.get("/ready").status_code == 200

def test_summary_contract():
    with TestClient(app) as client:
        r = client.get("/summary/INC-2048?delay=0")
        assert r.status_code == 200
        assert r.json()["severity"] == 2

def test_invalid_delay():
    with TestClient(app) as client:
        assert client.get("/summary/INC-2048?delay=7").status_code == 422
~~~

### BUILD / VALIDATE — Start healthy and capture baseline

~~~bash
docker compose -p archlab11 up -d --build
docker compose -p archlab11 ps
docker compose -p archlab11 exec api python -m pytest -q tests
curl -i http://127.0.0.1:18011/live
curl -i http://127.0.0.1:18011/ready
curl -sS -w '\nHTTP %{http_code} in %{time_total}s\n' \
  'http://127.0.0.1:18011/summary/INC-2048?delay=4'
~~~

**Expected:** three tests pass, health/readiness 200, summary 200 after about four seconds. If a 502 appears immediately after startup, inspect \`docker compose -p archlab11 logs gateway api\` and retry when ready. Do not inject a failure before the baseline works.

### BREAK 1 — Force an immediate process loss during an admitted request

Terminal A, from the project directory:

~~~bash
curl -v --max-time 8 \
  'http://127.0.0.1:18011/summary/INC-2048?delay=4'
~~~

While that request is running, Terminal B (same directory) executes **once**:

~~~bash
docker compose -p archlab11 kill -s SIGKILL api
docker compose -p archlab11 logs --tail=25 gateway api
~~~

**Expected:** Terminal A usually receives NGINX 502 or a connection error rather than a completed 200. If the timing misses the four-second window, repeat after restarting the API; do not claim the failure was reproduced if the request already completed.

### INVESTIGATE — Prove process loss, not DNS or SQL

~~~bash
docker compose -p archlab11 ps -a
docker compose -p archlab11 logs --tail=40 gateway api
docker compose -p archlab11 exec gateway nginx -t
docker compose -p archlab11 exec gateway getent hosts api
~~~

**Interpretation:** The gateway configuration and DNS can remain correct while the API process is gone. The gateway may log \`upstream prematurely closed connection\` or \`connect() failed\`; the precise message depends on timing. There is no database in this lab, so a DB root cause is impossible here. Distinguish *process crash* from *graceful deployment termination*; this first fault isolates the immediate interruption mechanism.

### FIX 1 — Restore API, then prepare for controlled drain

~~~bash
docker compose -p archlab11 up -d api
curl -i http://127.0.0.1:18011/ready
docker compose -p archlab11 exec api python -c \
 'import httpx; print(httpx.get("http://127.0.0.1:8000/metrics").json())'
~~~

**Expected:** readiness 200, active 0. Only proceed when restored.

### BREAK 2 / FIX 2 — Drain before stopping (one separate controlled scenario)

Terminal A:

~~~bash
curl -sS -w '\nHTTP %{http_code} in %{time_total}s\n' \
  'http://127.0.0.1:18011/summary/INC-2048?delay=4'
~~~

Within the four-second window, Terminal B:

~~~bash
docker compose -p archlab11 exec api python -c \
 'import httpx; print(httpx.post("http://127.0.0.1:8000/admin/drain").json())'
curl -i http://127.0.0.1:18011/ready
curl -i 'http://127.0.0.1:18011/summary/INC-2048?delay=0'
docker compose -p archlab11 exec api python -c \
 'import httpx; print(httpx.get("http://127.0.0.1:8000/metrics").json())'
~~~

**Expected:** readiness 503, new summary 503, but Terminal A's already-admitted request completes with 200. In a production setup, the load balancer should have routed the new request to another ready replica; this one-replica local lab deliberately shows the **instance-level** admission behavior instead.

Once Terminal A has completed, Terminal B:

~~~bash
docker compose -p archlab11 stop api
docker compose -p archlab11 logs --tail=40 api gateway
~~~

**Expected:** \`drain_started\`, \`request_completed\`, then \`shutdown\`, with active=0 at exit. This manually coordinated drain is intentionally deterministic and does not pretend that Docker Compose automatically performs endpoint removal.

### VALIDATE — Restart and run automated checks

~~~bash
docker compose -p archlab11 up -d api
curl -i http://127.0.0.1:18011/ready
curl -sS 'http://127.0.0.1:18011/summary/INC-2048?delay=0'
docker compose -p archlab11 exec api python -m pytest -q tests
docker compose -p archlab11 logs --tail=20 gateway api
~~~

**Expected:** readiness 200, summary 200, three passing tests. The design improvement is *coordination of admission and process lifecycle*, not increasing an arbitrary gateway timeout.

### Safe cleanup and learning evidence

~~~bash
docker compose -p archlab11 down
~~~

This affects only the named \`archlab11\` project. Do **not** use \`docker system prune\`, \`docker volume prune\`, or \`down -v\`; preserve unrelated Docker resources.

**Record:** healthy response timing; failure status and gateway log; API exit evidence; restored readiness; active count at drain; readiness/new-admission rejection; original request completion; graceful stop log; final tests. **Execute one step, share your actual output, and only then move to the next fault.** The complete reference remains here so you can work independently.

**Limitations and next production-grade extension:** The lab has one API replica and no real EndpointSlice/controller propagation. Extend it later with two API replicas and a dynamic proxy or local Kubernetes cluster to measure endpoint-removal lag and retry policies. Keep this lesson's single failure mechanism and review the tradeoff before adding complexity.

## My Architecture Review — Solutions & Doubts

### 1. My Understanding
_Write the request lifecycle, readiness versus liveness, and why deployment success can coexist with 502s._

### 2. My Solutions to the Architect Challenges
_Answer all three independently with calculations, assumptions, and tradeoffs._

### 3. My Troubleshooting Approach
_Chronology, commands, observed output, hypotheses, and evidence that ruled alternatives out._

### 4. My Proposed Architecture Improvements
_Admission control, drain budgets, rollout policy, deadline propagation, observability, rollback._

### 5. My Doubts / Questions
_Which behavior is still unclear? What experiment would settle it?_

### 6. Lessons Learned
_What would you change in a real deployment or incident response?_

### 7. Mentor Review
_Pending your submitted answers and actual lab evidence. Published is not completed._
