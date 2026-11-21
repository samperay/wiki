# Lesson 16 — Read Replica Lag, Read-Your-Writes & Consistency Contracts

**Reading and design: 20–25 minutes. Optional local practical lab: 60–90 minutes. Status: Published; hands-on unverified.**

**LEARN → DESIGN → BUILD → BREAK → INVESTIGATE → FIX → VALIDATE**

> **Architect question:** A user changes an incident to RESOLVED, receives HTTP 200, then refreshes and sees OPEN. Is the database broken, the API broken, or the product's consistency contract broken?

## 1. LEARN — The real problem

A multi-region incident platform writes authoritative incident state to PostgreSQL primary and serves dashboard reads from read replicas. Replication improves read capacity and availability, but the system must define *which* reads may be stale. An acknowledgment of a committed write is not a promise that every asynchronously replicated copy already contains it.

**Functional requirements:** Create/update incidents; retrieve by ID; list recent incidents; support an operator's immediate read after a successful update; provide auditability; expose replica health; permit graceful degradation when a replica is behind.

**Nonfunctional requirements:** 99.9% API availability; p99 read latency under 200 ms; 99.99% of immediate post-write reads must observe at least the acknowledged version (when served via a consistency-aware route); eventual dashboard reads may be up to 5 seconds stale; writes must remain durable across application restarts. These are *proposed targets*, not measured facts.

**Consistency vocabulary:** Strong read: observes the latest committed state at a defined linearization point. Read-your-writes: this caller does not observe an older version than its own acknowledged write. Monotonic reads: the caller does not move backward in versions. Eventual consistency: replicas converge if writes stop and replication resumes. These guarantees differ; a system may provide strong reads for a detail page and eventual reads for a search index.

### Capacity and lag budget

Assume 1,200 writes/s, 8,000 reads/s peak, average row update + WAL contribution 1.5 KiB per write. Approximate write-stream volume: 1,200 × 1.5 KiB ≈ **1.76 MiB/s** or 152 GiB/day before compression, indexes, full-page images and replication overhead. A 20-second stall accumulates ≈35 MiB of stream backlog; clearing it at *net* 3 MiB/s above incoming writes takes ≈12 seconds after recovery. This is an illustrative lower-bound model, not PostgreSQL sizing guidance.

At 8,000 reads/s and a 5-second lag, up to **40,000 read requests** occur during the stale window; only reads targeting recently changed records will be wrong, so do not equate this upper bound to actual affected users. Track the intersection of stale reads with changed keys.

For a bounded-wait design: 150 ms p99 API budget minus 25 ms network, 20 ms application overhead and 35 ms DB read leaves **70 ms** to wait for replica catch-up. If it cannot catch up, route the session-sensitive read to primary or return a documented temporary error. Waiting indefinitely is not a consistency strategy.

## 2. DESIGN — Evolve the architecture

### Stage A: One authoritative database

~~~mermaid
flowchart LR
  C["Client"] --> API["Incident API"]
  API --> P[("PostgreSQL primary")]
~~~

A single primary gives simple transaction semantics but constrains read scaling and couples reporting traffic to writes. Add caching only when its invalidation contract is explicit.

### Stage B: Split read/write paths

~~~mermaid
flowchart LR
  C["Client"] --> GW["API / router"]
  GW -->|"writes"| P[("Primary")]
  GW -->|"dashboard reads"| R[("Async replica")]
  P -.->|"WAL replication"| R
~~~

The dashed arrow is asynchronous replication. An HTTP 200 from primary does **not** establish replica freshness. A healthy TCP connection, SQL query and HTTP 200 can still deliver *semantically stale* data.

### Stage C: Explicit consistency contract

~~~mermaid
flowchart TB
  C["Client with min_version"] --> A["API router"]
  A --> D{"Read consistency?"}
  D -->|"eventual"| R[("Replica")]
  D -->|"read-your-writes"| V{"Replica version >= min_version?"}
  V -->|"yes"| R
  V -->|"no, within budget"| W["Bounded catch-up wait"]
  W --> V
  V -->|"budget exceeded"| P[("Primary")]
  A -->|"write"| P
  P -.->|"async replication"| R
~~~

**Design invariant:** A consistency-aware response must never return a record version below the client's acknowledged minimum. The client can pass a version token or the server can maintain an authenticated session watermark. The token must be scoped to the correct object/tenant and never grant authorization. In production, PostgreSQL WAL LSNs and replay positions can support replica freshness checks, but an LSN from one timeline cannot be naively compared across failover timelines. A per-record version works well for an illustrative contract but does not prove arbitrary cross-record snapshot consistency.

### Alternatives and tradeoffs

| Option | Correctness | Latency / availability | Operational cost |
| --- | --- | --- | --- |
| All reads from primary | Simple fresh reads | Primary load and failure coupling | Low complexity, limited scaling |
| All reads from replica | Eventual only | Low latency until lag, stale UI | Simple but weak UX contract |
| Sticky primary reads after writes | Read-your-writes within sticky window | Higher primary load | Session state and expiry |
| Version token + bounded wait + fallback | Explicit per-object monotonicity | Tail latency and fallback traffic | More logic and observability |
| Synchronous replication | Stronger commit acknowledgment conditions | Write latency/availability penalty | Quorum and failover complexity |

**Recommended split:** Use eventual reads for analytics/listing; use version-aware detail reads for recently modified incidents. Put a cap on primary fallback QPS, otherwise a replication incident becomes primary overload. Keep a fast fail-safe path for critical operations and separate permission checks from stale replicas.

## 3. BREAK — Hypothetical production incident

**This incident is fictional and all values below are illustrative.**

At 10:02, a schema-neutral maintenance operation creates heavy I/O on one read replica. WAL replay stalls for 18 seconds. Writes to primary continue at 1,200/s. An incident is marked RESOLVED at version 84 and the API returns 200 with version 84. A dashboard detail request routes to the replica at version 83 and returns OPEN with HTTP 200. Operators retry the update, creating duplicate notifications. At 10:03, replica lag clears; the incident appears RESOLVED.

**Blast radius:** Users with updates during the lag window, not necessarily all users; the write path is healthy. **User impact:** contradictory state and redundant actions. **Risk:** stale authorization decisions would be more serious than stale dashboards, so never place authorization on an unconstrained replica.

## 4. INVESTIGATE — Chronological, evidence-led diagnosis

**10:02:05 — Verify symptoms and avoid premature network diagnosis.**

~~~bash
curl -sS -D - https://incident.example.invalid/api/incidents/42
# Expected illustrative headers: X-Data-Source: replica; X-Record-Version: 83
# Body: {"id":42,"status":"OPEN","version":83}
~~~

Compare with the acknowledged write response, which included version 84. A successful TCP connection and HTTP 200 rule out many transport failures but do not prove freshness.

**10:02:15 — Check load balancer and process health.**

~~~bash
ss -tnp | grep ':5432'              # app host: DB TCP connections
getent hosts postgres-replica.internal # DNS resolution
curl -sS http://127.0.0.1:8080/health
journalctl -u incident-api --since "10:00" --no-pager | tail -80
~~~

Expected: stable DB connections and normal process health. If DNS/TCP is broken, diagnose separately; stale reads with working SQL point toward data propagation or routing semantics.

**10:02:30 — Measure PostgreSQL replication on the primary.**

~~~sql
SELECT application_name, state, sync_state,
       pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn) AS replay_bytes_behind,
       write_lag, flush_lag, replay_lag
FROM pg_stat_replication;
~~~

Expected hypothetical evidence: replay bytes behind increase while primary writes succeed. Note: lag interval fields may be NULL or reflect recent reporting, and byte lag is not wall-clock staleness. On the standby:

~~~sql
SELECT pg_is_in_recovery(), pg_last_wal_receive_lsn(),
       pg_last_wal_replay_lsn(),
       now() - pg_last_xact_replay_timestamp() AS time_since_last_replay_commit;
~~~

A large timestamp delta can also mean an idle primary, so correlate with incoming writes and LSN movement. Check replay pause state if supported by your PostgreSQL version and inspect storage/CPU metrics.

**10:02:45 — Investigate contention and storage.**

~~~bash
iostat -xz 1 5
vmstat 1 5
df -h
# DB pod/node: inspect disk await, utilization, CPU steal, throttling and I/O queue
~~~

~~~sql
SELECT pid, state, wait_event_type, wait_event, query
FROM pg_stat_activity
WHERE state <> 'idle' LIMIT 20;
~~~

Expected: replica I/O pressure or recovery wait; not evidence of primary commit failure. Inspect PostgreSQL logs and relevant cloud storage metrics. Do not run intrusive queries or terminate replay on a production replica without change control.

**10:03:00 — Correlate request traces and routing.**

Expected illustrative trace: write span db.role=primary, record.version=84; subsequent read span db.role=replica, record.version=83, client.min_version=84, consistency=eventual. This proves the API routed a read-your-writes request through an eventual-only path. Add a request ID to connect API logs to DB spans; redact incident content and user identifiers.

**10:03:15 — Separate causes.** Trigger: replica replay stalled under I/O contention. Immediate technical cause of wrong response: read router returned version 83 despite client requiring at least 84. Systemic weakness: no explicit consistency contract, version watermark, bounded wait, fallback budget, or alert on stale reads. Retries compounded duplicate side effects because consumers assumed the stale read meant the write had failed.

## 5. FIX — Mitigation, redesign and safeguards

**Immediate mitigation:** Route recently updated incident detail reads to primary, suppress duplicate user updates via idempotency keys, throttle noncritical reporting queries on lagging replicas, and communicate dashboard staleness. Watch primary CPU, connection pools and p99 latency as fallback traffic grows. Do not globally switch every read to primary without a capacity estimate.

**Long-term design:** Return a monotonically increasing per-record version on write; accept a client minimum version on read; if replica is behind, wait briefly and then fall back to primary within an admission budget. Keep analytics eventual and label it clearly. After failover, ensure the token/version semantics survive promotion; use a new epoch if ordering cannot be maintained. For multi-object workflows, use transaction/snapshot or an explicit domain-level consistency contract instead of treating per-record versions as a global snapshot.

**Operational safeguards:** Replication lag alerts, stale-read counter, fallback rate, primary headroom and a synthetic read-after-write probe. Readiness should distinguish *can answer eventual reads* from *can honor consistency-aware reads*. Never automatically restart a replica merely because lag rises; diagnose storage, replay and load first.

## 6. VALIDATE — Acceptance criteria

1. Healthy: write version N, immediate consistency-aware read returns version >= N.
2. Replica delayed: eventual read may show N-1, but consistency-aware read waits or falls back; it never returns N-1.
3. Replica disconnected: fallback succeeds within the primary capacity budget or returns a controlled 503; no infinite waits.
4. Primary unavailable: writes fail predictably; eventual reads may continue with explicitly stale semantics.
5. Repeated requests: idempotent updates do not duplicate notifications.
6. Metrics: \`replica_lag_bytes\`, \`replica_lag_seconds\`, \`stale_read_prevented_total\`, \`consistency_fallback_total\`, \`fallback_rejected_total\`, read p95/p99, primary saturation and replication replay rate.
7. Chaos: stop/resume replication, restart API, inject DB I/O latency in staging, and verify alerts and user-visible consistency contracts.

## 7. Architect challenges — answer independently

**Challenge A — Product semantics:** Which endpoints in an incident system require read-your-writes, which tolerate eventual consistency, and how would you document those guarantees to API clients?

**Challenge B — Capacity:** If 8,000 reads/s normally go to replicas, 15% become fallback requests during a lag event, and primary has 600 reads/s spare capacity, quantify the overload and propose a safe admission/fallback policy.

**Challenge C — Failover:** After a primary promotion changes WAL timeline, how will you preserve or invalidate client consistency tokens without incorrectly comparing unrelated LSNs?

## Practical Labs

**Environment:** Mac Docker Desktop recommended (allocate roughly 2 CPUs and 2 GiB free memory); Ubuntu VM is possible with Docker Engine + Compose plugin, but a 1-vCPU/1.9-GiB VM may be slow. **Optional hands-on: 60–90 minutes, separate from the 20–25-minute reading/design.** This lab models an *asynchronously refreshed read projection* inside one PostgreSQL instance; it is **not physical PostgreSQL streaming replication**. It reproduces the same observable consistency contract and stale-read failure while keeping resource use low. Production replication diagnosis remains in the architecture section above.

### BUILD — Prerequisites and directory

~~~bash
docker version
docker compose version
mkdir -p lesson16-consistency/app
cd lesson16-consistency
~~~

~~~text
lesson16-consistency/
├── compose.yaml
├── Dockerfile
├── requirements.txt
└── app/
    ├── main.py
    └── test_contract.py
~~~

Create each labeled file using \`cat > filename <<'EOF'\`, paste its block exactly, then type \`EOF\`. For app files, use \`cat > app/main.py <<'EOF'\` etc.

**File: requirements.txt**

~~~text
fastapi==0.115.12
uvicorn==0.34.2
psycopg[binary]==3.2.6
httpx==0.28.1
pytest==8.3.5
~~~

**File: Dockerfile**

~~~dockerfile
FROM python:3.12-slim
WORKDIR /code
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app ./app
ENV PYTHONPATH=/code
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
~~~

**File: compose.yaml**

~~~yaml
name: lesson16-consistency
services:
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: incidents
      POSTGRES_USER: lab
      POSTGRES_PASSWORD: lab-only
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U lab -d incidents"]
      interval: 2s
      retries: 20
    tmpfs:
      - /var/lib/postgresql/data
  api:
    build: .
    environment:
      DATABASE_URL: postgresql://lab:lab-only@db:5432/incidents
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "127.0.0.1:18016:8000"
~~~

**File: app/main.py**

~~~python
import os
import threading
import time
from contextlib import asynccontextmanager

import psycopg
from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel

DSN = os.environ["DATABASE_URL"]
pause = threading.Event()
stop = threading.Event()
worker = None


def connect():
    return psycopg.connect(DSN, autocommit=True)


def init_db():
    with connect() as db:
        db.execute("""
            CREATE TABLE IF NOT EXISTS authoritative (
                id integer PRIMARY KEY, status text NOT NULL, version bigint NOT NULL
            )
        """)
        db.execute("""
            CREATE TABLE IF NOT EXISTS projection (
                id integer PRIMARY KEY, status text NOT NULL, version bigint NOT NULL
            )
        """)
        db.execute("""
            INSERT INTO authoritative VALUES (42, 'OPEN', 1)
            ON CONFLICT (id) DO NOTHING
        """)
        db.execute("""
            INSERT INTO projection SELECT * FROM authoritative
            ON CONFLICT (id) DO NOTHING
        """)


def project():
    while not stop.wait(0.25):
        if pause.is_set():
            continue
        try:
            with connect() as db:
                db.execute("""
                    INSERT INTO projection (id, status, version)
                    SELECT id, status, version FROM authoritative
                    ON CONFLICT (id) DO UPDATE SET
                      status=EXCLUDED.status, version=EXCLUDED.version
                    WHERE projection.version < EXCLUDED.version
                """)
        except psycopg.Error as exc:
            print(f"projection_refresh_error={exc}", flush=True)


@asynccontextmanager
async def lifespan(app):
    global worker
    init_db()
    stop.clear()
    worker = threading.Thread(target=project, daemon=True)
    worker.start()
    yield
    stop.set()
    worker.join(timeout=2)


app = FastAPI(lifespan=lifespan)


class Change(BaseModel):
    status: str


@app.get("/health")
def health():
    return {"ok": True, "projection_paused": pause.is_set()}


@app.put("/incidents/42")
def update(change: Change):
    if change.status not in ("OPEN", "RESOLVED"):
        raise HTTPException(400, "invalid status")
    with connect() as db:
        row = db.execute("""
            UPDATE authoritative SET status=%s, version=version+1
            WHERE id=42 RETURNING id,status,version
        """, (change.status,)).fetchone()
    return {"id": row[0], "status": row[1], "version": row[2],
            "source": "primary"}


def read_from(table):
    with connect() as db:
        row = db.execute(
            f"SELECT id,status,version FROM {table} WHERE id=42"
        ).fetchone()
    return {"id": row[0], "status": row[1],
            "version": row[2], "source": table}


@app.get("/incidents/42")
def read(min_version: int = Query(default=0, ge=0),
         mode: str = Query(default="eventual")):
    if mode not in ("eventual", "consistent"):
        raise HTTPException(400, "invalid mode")
    item = read_from("projection")
    if mode == "eventual" or item["version"] >= min_version:
        return item
    deadline = time.monotonic() + 0.07
    while time.monotonic() < deadline:
        time.sleep(0.01)
        item = read_from("projection")
        if item["version"] >= min_version:
            return item
    item = read_from("authoritative")
    if item["version"] < min_version:
        raise HTTPException(503, "required version unavailable")
    item["fallback"] = True
    return item


@app.post("/lab/pause")
def pause_projection():
    pause.set()
    return {"paused": True}


@app.post("/lab/resume")
def resume_projection():
    pause.clear()
    return {"paused": False}


@app.get("/lab/versions")
def versions():
    a, b = read_from("authoritative"), read_from("projection")
    return {"primary": a["version"], "projection": b["version"],
            "lag_versions": a["version"] - b["version"]}
~~~

**File: app/test_contract.py**

~~~python
import time
import httpx

BASE = "http://api:8000"


def test_read_your_writes_and_recovery():
    with httpx.Client(timeout=5) as c:
        assert c.get(f"{BASE}/health").status_code == 200
        c.post(f"{BASE}/lab/resume").raise_for_status()
        # Let any prior projection work finish before the next fault.
        for _ in range(40):
            versions = c.get(f"{BASE}/lab/versions").json()
            if versions["lag_versions"] == 0:
                break
            time.sleep(0.1)
        assert c.get(f"{BASE}/lab/versions").json()["lag_versions"] == 0
        c.post(f"{BASE}/lab/pause").raise_for_status()
        try:
            write = c.put(f"{BASE}/incidents/42",
                          json={"status": "RESOLVED"}).json()
            stale = c.get(f"{BASE}/incidents/42",
                          params={"mode": "eventual"}).json()
            assert stale["version"] < write["version"]
            consistent = c.get(f"{BASE}/incidents/42",
                               params={"mode": "consistent",
                                       "min_version": write["version"]}).json()
            assert consistent["version"] >= write["version"]
            assert consistent["source"] == "authoritative"
            assert consistent["fallback"] is True
        finally:
            c.post(f"{BASE}/lab/resume").raise_for_status()
        for _ in range(40):
            if c.get(f"{BASE}/lab/versions").json()["lag_versions"] == 0:
                break
            time.sleep(0.1)
        assert c.get(f"{BASE}/lab/versions").json()["lag_versions"] == 0
~~~

**Safety boundary:** The lab control endpoints are intentionally unauthenticated and MUST NOT be exposed publicly or copied into production. The API binds to host loopback only. Database credentials are disposable; the DB uses tmpfs and is intentionally ephemeral.

### Healthy startup and baseline

~~~bash
docker compose up -d --build
docker compose ps
curl -fsS http://127.0.0.1:18016/health
curl -fsS http://127.0.0.1:18016/incidents/42
curl -fsS http://127.0.0.1:18016/lab/versions
~~~

Expected: healthy database, API ready, initial status OPEN/version 1, lag_versions 0. If not, inspect \`docker compose logs --tail=100 api db\`. **Pause here, record actual output and share it before proceeding to the first fault.**

### BREAK 1 — Stop projection refresh (one reversible failure)

~~~bash
curl -fsS -X POST http://127.0.0.1:18016/lab/pause
curl -fsS -X PUT http://127.0.0.1:18016/incidents/42 \
  -H 'Content-Type: application/json' -d '{"status":"RESOLVED"}'
curl -fsS http://127.0.0.1:18016/lab/versions
curl -fsS 'http://127.0.0.1:18016/incidents/42?mode=eventual'
~~~

Expected: write version 2, projection version 1, stale eventual response OPEN/version 1. A transient race at the exact pause boundary is possible; verify projection is paused before writing. This is *not* a TCP or SQL failure: both queries succeed but one reads an outdated projection.

### INVESTIGATE — Gather falsifiable evidence

~~~bash
docker compose logs --tail=80 api db
docker compose exec db psql -U lab -d incidents -c \
  'SELECT * FROM authoritative; SELECT * FROM projection;'
docker compose exec api python -c \
  "import socket; print(socket.getaddrinfo('db',5432)[0][4])"
curl -fsS 'http://127.0.0.1:18016/incidents/42?mode=consistent&min_version=2'
~~~

Expected: two table versions differ, DNS resolves, and consistency-aware read returns RESOLVED from \`authoritative\` with \`fallback:true\`. If a previous run incremented the version beyond 2, replace \`min_version=2\` with the version returned by the PUT response. Record both versions, data source and reason for fallback.

### FIX — Resume projection and verify convergence

~~~bash
curl -fsS -X POST http://127.0.0.1:18016/lab/resume
sleep 2
curl -fsS http://127.0.0.1:18016/lab/versions
curl -fsS 'http://127.0.0.1:18016/incidents/42?mode=eventual'
~~~

Expected: lag_versions 0 and both reads RESOLVED. A production repair would also eliminate the replay bottleneck, bound fallback load, and alert on consistency violations; simply resuming a worker is not a durable architecture improvement.

### VALIDATE — Automated contract test

~~~bash
docker compose exec api pytest -q app/test_contract.py
# Expected: 1 passed
docker compose logs --tail=50 api
~~~

The test exercises pause → stale eventual read → version-aware primary fallback → resume → convergence. **Do not mark verified until you actually run it and capture the output.** Do not inject a second fault until the first is fully recovered.

### Safe cleanup

~~~bash
docker compose down --remove-orphans
cd ..
~~~

This removes only the lesson's containers and network. The DB is ephemeral tmpfs. Do **not** run \`docker compose down -v\`, \`docker volume prune\` or \`docker system prune\`; preserve unrelated Docker resources. Keep the source directory to repeat the exercise.

## My Architecture Review — Solutions & Doubts

### 1. My Understanding

_Describe the difference between a successful committed write and an immediately fresh replica read. What consistency guarantee does the API actually provide?_

### 2. My Solutions to the Architect Challenges

_A: Endpoint classification and contract:_

_B: Fallback overload calculation and admission policy:_

_C: Failover token semantics:_

### 3. My Troubleshooting Approach

_Initial hypotheses, chronological commands, expected versus actual observations, and the evidence that eliminated DNS/TCP issues:_

### 4. My Proposed Architecture Improvements

_Design changes, capacity limits, fallback tradeoffs and operational runbooks:_

### 5. My Doubts / Questions

_Questions to review together:_

### 6. Lessons Learned

_What changed in your thinking about read scalability and consistency?_

### 7. Mentor Review

_Pending. Share your reasoning and actual lab outputs for evidence-based feedback; do not mark complete merely because this lesson is published._
