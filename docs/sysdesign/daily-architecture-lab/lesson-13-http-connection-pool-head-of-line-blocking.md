# Lesson 13 — HTTP Connection Pool Saturation and Cascading Timeouts

**Reading/design: 20–25 minutes. Optional hands-on: 40–60 minutes. Status: Published; hands-on not verified.**

**LEARN → DESIGN → BUILD → BREAK → INVESTIGATE → FIX → VALIDATE**

**Networking revision:** [Keepalive, Pooling and Timeouts](../../networking/performance/keepalive-pooling-timeouts.md) is the canonical networking reference. This architecture incident builds on it without repeating its tutorial. Unlike Lesson 07, this is **HTTP client** pool saturation, not PostgreSQL pool exhaustion.

## LEARN — Realistic architecture problem

An incident summary service retrieves mandatory incident fields locally and optional owner metadata from another service. A metadata deployment introduces 2-second latency. The summary service's small HTTP connection pool fills; waiting requests time out even though the metadata host has spare CPU. The system needs to preserve essential incident responses, bound resource usage, and reveal whether a timeout happened before or after a connection was acquired.

### Functional requirements

1. Return incident ID and severity even when informational owner enrichment fails.
2. Mark partial responses explicitly; never invent owner identity.
3. Preserve correlation IDs and distinguish dependency errors.
4. Provide health and per-dependency diagnostics.
5. Keep authorization-critical data fail-closed; optional enrichment alone may degrade.

### Nonfunctional requirements and quantitative capacity

| Dimension | Illustrative requirement |
| --- | --- |
| Load | 120 requests/s steady; 300 requests/s 30-second burst |
| Core summary p99 | Under 800 ms |
| Healthy metadata | 40 ms mean, 180 ms p99 |
| Degraded metadata | 2 seconds mean |
| Summary replicas | 6 |
| HTTP pool per replica | 12 connections |
| Global connection budget | 72 connections, assuming one process per replica |
| Enrichment budget | 350 ms total including pool wait |
| Pool acquire wait | At most 100 ms |
| Availability | 99.9% for core incident data |

Little's Law: at 300 requests/s and 2 seconds mean latency, unconstrained demand is roughly **600 concurrent calls**. A 72-slot pool sustains at most 36 calls/s under that latency. A 30-second 300-rps burst offers 9,000 requests, while the pool can finish approximately 1,080. Queueing without admission control is not a solution. Simply enlarging the pool can overload the metadata service.

## DESIGN — Incremental architectures

### 1. Mandatory synchronous dependency

~~~mermaid
flowchart LR
    Client --> NGINX --> Summary --> Metadata
~~~

A slow metadata response blocks essential incident data.

### 2. Expose client-side queues and replica multiplication

~~~mermaid
flowchart LR
    G[NGINX] --> A[Summary replica A]
    G --> B[Summary replica B]
    A --> P1[HTTP pool 12]
    B --> P2[HTTP pool 12]
    P1 --> M[Metadata]
    P2 --> M
    P1 -. saturation .-> Q1[Pool waiters]
    P2 -. saturation .-> Q2[Pool waiters]
~~~

Pool limits are per process. HTTP/2 may multiplex requests on one connection, so socket count is not always request concurrency. Keep pool waiting distinct from TCP connection establishment, TLS negotiation, upstream execution and proxy timeout.

### 3. Bounded optional enrichment

~~~mermaid
flowchart LR
    Client --> Gateway --> Summary
    Summary --> Core[Mandatory incident result]
    Summary --> Gate[Bounded enrichment semaphore]
    Gate --> Pool[HTTP client pool] --> Metadata
    Gate -. timeout/rejection .-> Partial[Explicit owner unavailable]
    Core --> Response
    Metadata --> Response
    Partial --> Response
~~~

An 800-ms end-to-end budget could allocate 100 ms proxy/network, 100 ms core work, 350 ms enrichment, and 250 ms margin. The gateway's upstream deadline must allow the application to return a meaningful partial response. A production implementation propagates the *remaining* caller deadline, not independent fixed timeouts.

### Alternatives and tradeoffs

| Alternative | Benefit | Drawback / decision |
| --- | --- | --- |
| Bigger HTTP pool | More concurrency while healthy | More downstream pressure; require measured capacity |
| Bounded semaphore | Prevents unlimited local work | Replicas multiply the cap; use here |
| Short pool timeout | Fails promptly on saturation | Must map optional failure to partial result |
| Owner cache | Reduces dependency calls | Staleness and invalidation |
| Circuit breaker | Limits repeated failing calls | State and recovery tuning |
| Async enrichment | Removes dependency from request path | Eventual consistency and operational complexity |
| Retries | May hide brief network faults | Can amplify overload; avoid during saturation |

## Hypothetical production incident — evidence-led investigation

**Fictional training scenario only, not an actual production event.** Times and measurements below are illustrative.

| UTC | Evidence | Interpretation |
| --- | --- | --- |
| 09:00 | Metadata rollout; p99 180 ms → 2 s | Suspected trigger |
| 09:02 | Summary p99 210 ms → 2.9 s; 503s 12% | User impact |
| 09:03 | Client pool 12/12 occupied per replica | Saturation in caller |
| 09:04 | Pool acquire p95 1.1 s; metadata CPU 45% | Waiting may be client-side |
| 09:05 | NGINX 504 rate rises | Gateway timeout, not proof of network failure |
| 09:08 | More summary replicas added; metadata RPS doubles | Scale-out amplifies load |
| 09:12 | Enrichment bounded and made optional | Core availability recovers |
| 09:35 | Metadata rollback | Trigger removed, systemic risk remains |

### Chronological commands and expected evidence

**First: establish user impact.** From a permitted Linux application host:

~~~bash
date -u
curl -sv --max-time 4 http://summary.internal/summary?id=INC-123
sudo ss -tanp | grep -E ':80|:8000|:9000' | head -30
sudo journalctl -u summary-api --since '2026-11-18 09:00:00 UTC' --no-pager | tail -80
~~~

Illustrative log:

~~~text
09:04:11 request_id=ab12 event=enrichment_failed type=PoolTimeout
09:04:12 request_id=ab13 status=503 elapsed_ms=3020
~~~

A **PoolTimeout** means the caller could not acquire a connection from its client pool in time; it does not prove DNS, TCP, firewall, or database failure.

**Second: check upstream from the caller's namespace.**

~~~bash
getent hosts metadata.internal
curl -sS -o /dev/null -w 'dns=%{time_namelookup} connect=%{time_connect} first_byte=%{time_starttransfer} total=%{time_total}\n' --max-time 4 http://metadata.internal/owner/INC-123
ss -s
# Only with authorization:
sudo tcpdump -ni any 'tcp port 9000' -c 40
~~~

A fast TCP handshake plus a slow first byte points toward upstream work, but cannot prove which internal component is slow. Packet capture vantage point matters. Inspect traces for admission wait, pool acquire, connect, upstream first byte and response rendering; a generic HTTP span alone cannot separate these phases.

**Third: rule out unrelated bottlenecks.** If PostgreSQL is present in production, inspect its activity independently rather than treating every "pool" as a database pool:

~~~sql
SELECT state, wait_event_type, wait_event, count(*)
FROM pg_stat_activity GROUP BY 1,2,3 ORDER BY 4 DESC;
~~~

**Immediate cause:** long metadata requests occupy the HTTP client pool, forcing new callers to wait and expire. **Trigger:** slower metadata deployment. **Systemic weakness:** optional enrichment on mandatory request path, no bounded admission, incoherent deadlines. **Amplifier:** replicas and retries multiply load.

## MITIGATE — restore core service

Bound optional enrichment, stop automatic retries, return a clearly marked partial response, and roll back the metadata regression when safe. Check core success rate, partial-response rate, pool waits, upstream load and user p99. Lower 504 count alone does not prove recovery.

## FIX — long-term redesign

Consider cached or asynchronously populated owner metadata with freshness and invalidation rules. Propagate caller deadlines, limit work per destination and per tenant, measure pool acquisition separately from network timing, and enforce a distributed downstream concurrency budget where necessary. If ownership determines authorization, fail closed instead of returning partial data.

## Observability and validation

| Signal | Illustrative alert | Meaning |
| --- | --- | --- |
| Core summary p99 | >800 ms for 5 min | Critical-path regression |
| HTTP pool wait p95 | >75 ms for 3 min | Pool contention |
| Pool timeout ratio | >1% for 3 min | Client saturation |
| Partial response ratio | >5% for 5 min | Optional dependency degraded |
| Metadata p99 | >500 ms for 5 min | Upstream regression |
| Retry amplification | >1.2 calls/original request | Overload risk |

Validate at 120 rps steady and 300 rps burst, with 2-second dependency delay, across replica counts; check file descriptors, CPU, socket states, error budget and recovery. Canary 5% → 25% → full only if core p99, partial rate and upstream concurrency remain acceptable.

## Three independent architect challenges

1. Calculate throughput with 72 connections and 2-second service time at 300 rps. Explain where to shed load and why raising the pool size could worsen p99.
2. A proposed client uses two 500-ms retries inside an 800-ms user deadline. Design a consistent timeout hierarchy and justify when zero retries is best.
3. Metadata CPU is 40% while summary pool wait is high. Provide three competing hypotheses, falsifying evidence for each, and explain what changes under HTTP/2.

---

## Practical Labs

**Optional hands-on 40–60 minutes, separate from reading.** Recommended: **Mac M4 Docker Desktop**, approximately 1–1.5 GiB RAM. Ubuntu VM is possible with Docker Compose v2 but the user's 1-vCPU/1.9-GiB VM is resource-constrained. No database or Redis: the actual failure is an HTTP client pool, so adding them would obscure the diagnosis. Host port is bound only to localhost.

### BUILD — prerequisites and file creation

Check \`docker version\`, \`docker compose version\`, \`python3 --version\` and \`curl --version\`. On Ubuntu, prefix Docker commands with \`sudo\` if needed. Use a fresh isolated directory:

~~~bash
mkdir -p ~/architecture-lab13/{summary,metadata,nginx,tests}
cd ~/architecture-lab13
~~~

~~~text
architecture-lab13/
├── compose.yaml
├── Dockerfile
├── requirements.txt
├── summary/app.py
├── metadata/app.py
├── nginx/default.conf
└── tests/validate.py
~~~

Create the following labeled files with \`nano <path>\` or VS Code, copying each code block.

**File: requirements.txt**

~~~text
fastapi==0.115.12
uvicorn==0.34.2
httpx==0.28.1
~~~

**File: Dockerfile**

~~~dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY summary/ /app/summary/
COPY metadata/ /app/metadata/
ENV PYTHONUNBUFFERED=1
~~~

**File: metadata/app.py**

~~~python
import asyncio
import os
from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
async def health():
    return {"status": "ok"}

@app.get("/owner/{incident_id}")
async def owner(incident_id: str):
    delay = float(os.getenv("METADATA_DELAY", "0.03"))
    await asyncio.sleep(delay)
    return {"incident_id": incident_id, "owner": "platform-ops"}
~~~

**File: summary/app.py**

~~~python
import asyncio
import logging
import os
import time
from contextlib import asynccontextmanager
import httpx
from fastapi import FastAPI, HTTPException

logging.basicConfig(level=logging.INFO)
log = logging.getLogger("summary")
PROTECTED = os.getenv("PROTECTED", "0") == "1"
POOL_SIZE = 2
GATE = asyncio.Semaphore(POOL_SIZE)

@asynccontextmanager
async def lifespan(app: FastAPI):
    app.state.client = httpx.AsyncClient(
        limits=httpx.Limits(max_connections=POOL_SIZE, max_keepalive_connections=POOL_SIZE),
        timeout=httpx.Timeout(connect=0.2, read=3.0, write=0.2, pool=0.15),
    )
    yield
    await app.state.client.aclose()

app = FastAPI(lifespan=lifespan)

@app.get("/health")
async def health():
    return {"status": "ok", "protected": PROTECTED}

async def enrich(incident_id):
    r = await app.state.client.get("http://metadata:9000/owner/" + incident_id)
    r.raise_for_status()
    return r.json()["owner"]

@app.get("/summary")
async def summary(id: str = "INC-123"):
    started = time.monotonic()
    result = {"incident_id": id, "severity": 2, "owner": None, "owner_status": "unavailable"}
    if PROTECTED:
        try:
            await asyncio.wait_for(GATE.acquire(), timeout=0.04)
        except asyncio.TimeoutError:
            log.warning("event=admission_rejected id=%s", id)
            return result
        try:
            result["owner"] = await asyncio.wait_for(enrich(id), timeout=0.30)
            result["owner_status"] = "ok"
        except (httpx.HTTPError, asyncio.TimeoutError) as exc:
            log.warning("event=enrichment_failed type=%s", type(exc).__name__)
        finally:
            GATE.release()
    else:
        try:
            result["owner"] = await enrich(id)
            result["owner_status"] = "ok"
        except httpx.HTTPError as exc:
            log.error("event=pool_or_upstream_failure type=%s", type(exc).__name__)
            raise HTTPException(status_code=503, detail=type(exc).__name__) from exc
    log.info("event=summary_complete status=%s elapsed_ms=%.1f",
             result["owner_status"], (time.monotonic()-started)*1000)
    return result
~~~

**File: nginx/default.conf**

~~~nginx
server {
    listen 8080;
    access_log /dev/stdout;
    error_log /dev/stderr warn;
    location / {
        proxy_pass http://summary:8000;
        proxy_connect_timeout 1s;
        proxy_read_timeout 4s;
        proxy_set_header X-Request-ID $request_id;
    }
}
~~~

**File: compose.yaml**

~~~yaml
name: architecture-lab13
services:
  metadata:
    build: .
    command: uvicorn metadata.app:app --host 0.0.0.0 --port 9000
    environment:
      METADATA_DELAY: "0.03"
  summary:
    build: .
    command: uvicorn summary.app:app --host 0.0.0.0 --port 8000
    environment:
      PROTECTED: "0"
    depends_on:
      - metadata
  nginx:
    image: nginx:1.27-alpine
    ports:
      - "127.0.0.1:18083:8080"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - summary
~~~

**File: tests/validate.py**

~~~python
import concurrent.futures
import json
import sys
import time
import urllib.error
import urllib.request

URL = "http://127.0.0.1:18083/summary?id=INC-123"

def request(_):
    started = time.monotonic()
    try:
        with urllib.request.urlopen(URL, timeout=6) as response:
            return response.status, json.loads(response.read()), time.monotonic()-started
    except urllib.error.HTTPError as exc:
        return exc.code, {}, time.monotonic()-started

def main():
    mode = sys.argv[1]
    with concurrent.futures.ThreadPoolExecutor(max_workers=8) as pool:
        results = list(pool.map(request, range(8)))
    codes = [r[0] for r in results]
    partial = sum(r[1].get("owner_status") == "unavailable" for r in results)
    print("status counts:", {c: codes.count(c) for c in set(codes)})
    print("partial:", partial, "max seconds:", round(max(r[2] for r in results), 3))
    if mode == "healthy":
        assert all(c == 200 and body["owner_status"] == "ok" for c, body, _ in results)
    elif mode == "broken":
        assert 503 in codes
    elif mode == "protected":
        assert all(c == 200 and body["incident_id"] == "INC-123" for c, body, _ in results)
        assert partial >= 1
    else:
        raise ValueError("healthy | broken | protected")
    print("PASS:", mode)

if __name__ == "__main__":
    main()
~~~

**Healthy startup and baseline:**

~~~bash
docker compose up -d --build
docker compose ps
curl -fsS http://127.0.0.1:18083/health
curl -fsS 'http://127.0.0.1:18083/summary?id=INC-123'
python3 tests/validate.py healthy
~~~

Expected: all three containers running; summary includes owner \`platform-ops\`, status \`ok\`; test prints \`PASS: healthy\`. Wait for startup if needed. Do not inject a fault before baseline passes.

### BREAK — one controlled reversible upstream delay

Change **only** the metadata delay in \`compose.yaml\` from \`"0.03"\` to \`"2"\` and run:

~~~bash
docker compose up -d --no-deps --force-recreate metadata
python3 tests/validate.py broken
~~~

Expected: at least one HTTP 503 from HTTPX \`PoolTimeout\`; the first two requests may succeed slowly. Exact order varies by scheduler. If flaky, rerun and collect logs; never invent results.

### INVESTIGATE — correlate evidence

~~~bash
docker compose logs --tail=100 summary
docker compose logs --tail=50 metadata
docker compose logs --tail=50 nginx
docker compose exec summary python -c "import socket; print(socket.getaddrinfo('metadata',9000)[0][4])"
docker compose exec summary python -c "import httpx,time; t=time.monotonic(); r=httpx.get('http://metadata:9000/owner/INC-123',timeout=4); print(r.status_code,round(time.monotonic()-t,2))"
docker compose exec summary sh -c "head /proc/net/tcp"
~~~

Expected: DNS resolves; direct metadata call takes ~2 seconds; summary logs show \`PoolTimeout\` under concurrent load. Socket snapshots do **not** directly prove pool wait; HTTP client exception is stronger evidence.

### FIX — protect optional enrichment without healing metadata

Change **only** \`PROTECTED: "0"\` to \`PROTECTED: "1"\` in \`compose.yaml\`, leaving metadata delay at 2 seconds:

~~~bash
docker compose up -d --no-deps --force-recreate summary
python3 tests/validate.py protected
docker compose logs --tail=80 summary
~~~

Expected: HTTP 200 for all core summaries with \`owner_status=unavailable\` for some/all; admission rejects or enrichment timeouts in logs. This proves graceful degradation, **not** that metadata is fixed.

### VALIDATE — recover upstream and verify full enrichment

Change \`METADATA_DELAY: "2"\` back to \`"0.03"\` in \`compose.yaml\`:

~~~bash
docker compose up -d --no-deps --force-recreate metadata
python3 tests/validate.py healthy
curl -fsS 'http://127.0.0.1:18083/summary?id=INC-123'
~~~

Expected: \`owner_status=ok\`, owner \`platform-ops\`, test PASS. If startup races, wait and retry. These local tests do not establish production SLOs.

### Safe cleanup

~~~bash
cd ~/architecture-lab13
docker compose down --remove-orphans
docker compose ps
~~~

This project defines no named volumes. Do **not** run \`docker system prune\`, \`docker volume prune\` or unrelated Compose commands. Keep source files for review. Execute **one step at a time**, share actual outputs, and proceed to the next fault only after verification.

---

## My Architecture Review — Solutions & Doubts

### 1. My Understanding

_Explain the architecture, pool queue and critical versus optional data._

### 2. My Solutions to the Architect Challenges

_Answer each of the three questions with calculations and tradeoffs._

### 3. My Troubleshooting Approach

_Record actual commands, evidence, hypotheses and falsifying observations._

### 4. My Proposed Architecture Improvements

_Distinguish mitigation from long-term design._

### 5. My Doubts / Questions

_Add open questions._

### 6. Lessons Learned

_Separate trigger, immediate cause, systemic weakness and verified recovery._

### 7. Mentor Review

_Pending. Review reasoning and evidence after solutions are submitted._
