# Daily Architecture Incident Lab — Lesson 10
## Noisy Neighbors: Multi-Tenant Rate Limiting and Shared Database Protection

**Date:** 15 November 2026. **Reading/design:** 20–25 minutes. **Optional practical lab:** 60–90 minutes separately. All incidents, metrics and timestamps are **hypothetical**.

**LEARN → DESIGN → BUILD → BREAK → INVESTIGATE → FIX → VALIDATE**

## 1. LEARN — Problem and requirements (0–4 min)

An internal incident dashboard serves tenant alpha and tenant beta through NGINX, FastAPI and PostgreSQL. Alpha's new polling script jumps from 100 to 4,000 requests/second. Beta stays at 150 RPS, but its incident reads time out because both tenants share the same finite database and application resources.

**Restaurant analogy:** A large walk-in party occupies all tables. A receptionist needs per-party admission rules, while the kitchen also needs a limit on simultaneous orders. Rate limits and concurrency limits solve different problems.

**Functional requirements:** authenticate tenant identity; preserve beta's incident status reads; return 429 and Retry-After for over-quota requests; make limiter failures explicit; correlate request IDs, tenant, latency and DB pressure; support audited emergency policy overrides. **Security:** the lab uses a client-supplied X-Lab-Tenant header solely for learning. In production the gateway must verify OIDC/mTLS identity and strip untrusted tenant headers.

| Nonfunctional target (hypothetical) | Value |
|---|---|
| Normal peak | 1,200 RPS |
| Alpha / beta quotas | 300 / 200 RPS |
| p95 / p99 | ≤150 / ≤400 ms |
| API replicas | 6 |
| Fleet DB connections | 120 usable |
| Availability | 99.9% monthly |
| Limiter decision p99 | ≤10 ms |
| Redis outage policy | Lab fails closed; production requires risk assessment |

## 2. DESIGN — Capacity, diagrams, alternatives (4–8 min)

Little's Law: at 1,200 RPS and 50 ms average DB service time, concurrency demand is 1,200 × 0.05 = **60**. At 5,000 RPS and 200 ms, demand is **1,000**; a 120-connection fleet budget cannot sustain that. Six replicas × 40 connections = 240 possible DB connections, twice the budget. Six × 15 = 90 with 30 reserved is a possible initial allocation, subject to load testing. Rate limiting does not cap concurrency: 100 RPS × 2 seconds = 200 in-flight operations.

**Version A: no isolation**

~~~mermaid
flowchart LR
 A["Alpha poller"] --> G["NGINX"]
 B["Beta dashboard"] --> G
 G --> F["FastAPI replicas"]
 F --> D[("PostgreSQL")]
~~~

**Version B: distributed quota**

~~~mermaid
flowchart LR
 A["Alpha"] --> G["NGINX"]
 B["Beta"] --> G
 G --> F["FastAPI"]
 F --> R[("Redis atomic quota")]
 F --> D[("PostgreSQL")]
 R -. "429 excess" .-> F
~~~

**Version C: production design**

~~~mermaid
flowchart LR
 C["Verified clients"] --> E["Identity-aware gateway"]
 E --> L["Global per-tenant quota"]
 L --> H["Endpoint concurrency bulkheads"]
 H --> F["FastAPI"]
 F --> D[("PostgreSQL")]
 L --> R[("HA Redis")]
 H --> O["Metrics/traces"]
~~~

| Alternative | Benefit | Cost / weakness |
|---|---|---|
| NGINX limit_req | Reject early | Global multi-gateway tenant quota and trusted identity need extra work |
| In-process bucket | Fast | Each replica independently grants quota |
| Redis fixed-window Lua | Atomic global decision | Window-boundary burst, Redis dependency |
| GCRA/token bucket | Smoother rate | More state and complexity |
| Mesh/API gateway | Central policy | Operational complexity |
| Async queue | Handles delay-tolerant work | Not appropriate for fresh incident status |

The lab chooses Redis fixed windows to expose a real distributed policy. A 300-per-second fixed-window quota can admit nearly 600 requests across adjacent window boundaries. Production should evaluate GCRA, weighted endpoint cost, identity enforcement and DB bulkheads.

## 3. Hypothetical incident — Evidence-led investigation (8–17 min)

**Explicitly hypothetical, 09:00–09:25 UTC.**

| UTC | Evidence | Reasoning |
|---|---|---|
| 09:00 | Alpha poller deployed | Correlation, not causation yet |
| 09:02 | Alpha 4,000 RPS; beta 150 RPS | Tenant imbalance |
| 09:04 | Active requests 980; DB checkout p95 900 ms | Queueing and DB admission |
| 09:06 | Beta p99 3 seconds | Cross-tenant blast radius |
| 09:09 | Gateway 504 9%; DB CPU 45% | CPU not primary bottleneck |
| 09:12 | Alpha paused; beta p99 260 ms | Load causality supported |
| 09:18 | Temporary tenant quota deployed | Test protection |
| 09:25 | Beta recovery and rollback verified | Not yet durable prevention |

**A. Authorized client probe:**

~~~bash
for i in 1 2 3; do
 curl -sS -o /dev/null --max-time 4 \
 -H 'Authorization: Bearer <REDACTED>' \
 -H "X-Request-ID: check-$i" \
 -w 'status=%{http_code} total=%{time_total}s connect=%{time_connect}s\n' \
 https://incident-api.example.internal/incidents/INC-2048
done
~~~

Illustrative output: status=504 total=3.002s connect=0.011s. Fast connect with slow total suggests downstream waiting, not which dependency failed.

**B. Gateway and Linux sockets, on the relevant host:**

~~~bash
ss -s
ss -tan state established | head
sudo grep 'upstream timed out' /var/log/nginx/error.log | tail -20
sudo tail -20 /var/log/nginx/access.log
ps -eo pid,stat,%cpu,%mem,cmd --sort=-%cpu | head
journalctl -u incident-api --since '2026-11-15 09:00:00 UTC' --no-pager | tail -30
~~~

Illustrative NGINX: status=504 request_time=3.001 upstream_response_time=3.000. Illustrative API: tenant=beta pool_checkout_ms=1180 sql_ms=38 active_requests=980. A gateway 504 is a symptom, not proof NGINX is faulty.

**C. PostgreSQL read-only diagnosis:**

~~~sql
SELECT state,wait_event_type,wait_event,count(*)
FROM pg_stat_activity WHERE datname=current_database()
GROUP BY 1,2,3 ORDER BY 4 DESC;
SELECT application_name,state,count(*)
FROM pg_stat_activity GROUP BY 1,2 ORDER BY 3 DESC;
~~~

Illustrative: active=65, idle=35. Pool checkout wait inside the application may not appear in pg_stat_activity. Correlate application pool wait histograms, query durations and DB sessions.

**D. Redis and trace investigation (authorized environment only):**

~~~bash
redis-cli -h redis.internal PING
redis-cli -h redis.internal INFO stats | grep instantaneous_ops_per_sec
redis-cli -h redis.internal INFO memory | grep used_memory_human
~~~

Illustrative trace:

~~~text
trace=req-b2 tenant=beta GET /incidents/INC-2048 3002ms
  application admission/queue 1160ms
  DB pool checkout            1180ms
  SQL query                     38ms
  response overhead             12ms
~~~

Spans can overlap; never sum them without timestamps. Compare tenant-level latency, 429s, Redis decision errors, DB pool checkout, gateway 504s and connection counts. Control metric label cardinality.

**Competing hypotheses:** DNS/network would affect connect/retransmits; slow SQL would raise query execution time; here pool checkout dominates. Alpha's load precedes beta degradation, and beta recovers when alpha is paused. Redis outage is a **separate** failure after limiter deployment.

**Trigger:** Alpha polling rollout. **Immediate cause:** Shared application and DB admission saturated. **Systemic weakness:** No per-tenant quotas, DB concurrency isolation, tenant SLO metrics or noisy-neighbor load tests. Reverting alpha fixes today, not tomorrow.

## 4. FIX — Mitigation and durable redesign (17–21 min)

Immediately pause alpha, introduce a temporary verified-identity quota, bound DB checkout time, protect critical incident reads and document rollback. Do not scale replicas blindly: each replica may increase DB connections. Long-term: global tenant budgets, separate read/write limits, per-endpoint costs, bounded bulkheads and queues, jittered client backoff, Redis HA, versioned policies and audited time-limited overrides.

**Redis failure tradeoff:** Fail-open risks uncontrolled DB overload; fail-closed causes 503s; bounded emergency local quotas may be appropriate for trusted critical reads. The lab deliberately fails closed. A 429 should include Retry-After and clients must back off with jitter. Fixed windows risk boundary bursts; GCRA reduces them at additional implementation cost.

## 5. OPERATE — Observability and validation (21–23 min)

| Signal | Expected evidence |
|---|---|
| Allowed/rejected per tenant | Alpha gets 429, beta unaffected |
| Beta p95/p99 | Within SLO during alpha burst |
| DB checkout and sessions | Below fleet allocation |
| Redis limiter p99/errors | Fast decisions, explicit failure policy |
| Active requests/queue depth | Bounded |
| Gateway 502/504 | Low during expected load |
| Override audit | Identity, reason, expiry and rollback |

Validate below/at/above quota, simultaneous tenants, fixed-window boundaries, 1→6 replicas, DB slowness, Redis failure/recovery and policy rollback in staging. Do not flood production. Measure beta's latency, not just alpha's 429 count.

## 6. Three independent architect challenges (23–25 min)

1. **Burst mathematics:** Why can a 300-per-second fixed window allow ~600 requests at a boundary? Choose a smoother algorithm and explain cost.
2. **Limiter outage:** Redis fails for 90 seconds during a critical incident. Choose fail-open, fail-closed or bounded emergency local quotas; justify security, DB capacity, fairness and availability.
3. **Replica budget:** Six replicas each have a pool of 20 connections, consuming 120 usable connections. What changes at ten replicas? Propose admission and connection budgets.

Write your own assumptions, calculations and tradeoffs before seeking review.

## Practical Labs

**Optional 60–90 minutes; independent of 20–25-minute reading.** This is the **same alpha/beta incident API**, not an unrelated proxy demo. Run one step, inspect and share actual output, then proceed to the next fault.

**Host:** Prefer Mac Docker Desktop (~2 GB free RAM, ~1 GB disk) or Ubuntu VM with Docker Engine and Compose (~2 GB RAM). On Ubuntu use docker group access or consistently prefix commands with sudo. The 1-vCPU/1.9-GiB VM may struggle; use Mac if available. Bind only to localhost and do not touch existing NGINX.

~~~bash
docker version
docker compose version
mkdir -p ~/architecture-labs/lesson10-noisy-neighbor/{app,nginx,tests}
cd ~/architecture-labs/lesson10-noisy-neighbor
touch app/__init__.py
~~~

Create each labeled file by running cat > filename <<'EOF', pasting its entire fenced block, then ending with EOF on a line by itself.

~~~text
lesson10-noisy-neighbor/
├── app/
│   ├── __init__.py
│   └── main.py
├── nginx/
│   └── default.conf
├── tests/
│   └── test_contract.py
├── requirements.txt
├── Dockerfile
└── compose.yaml
~~~

**File: requirements.txt**

~~~text
fastapi==0.115.12
uvicorn==0.34.2
redis==5.2.1
psycopg[binary]==3.2.6
httpx==0.28.1
pytest==8.3.5
~~~

**File: Dockerfile**

~~~dockerfile
FROM python:3.11-slim
WORKDIR /code
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app ./app
COPY tests ./tests
CMD ["uvicorn","app.main:app","--host","0.0.0.0","--port","8000"]
~~~

**File: app/main.py**

~~~python
import os,time,logging
from contextlib import asynccontextmanager
import psycopg
from fastapi import FastAPI,Header,HTTPException
from redis import Redis
from redis.exceptions import RedisError
log=logging.getLogger("lesson10")
redis_client=Redis(host="redis",decode_responses=True,
                   socket_connect_timeout=0.15,socket_timeout=0.15)
dsn=os.getenv("DATABASE_URL","postgresql://lab:lab@db:5432/lab")
stats={"allowed":0,"rejected":0,"redis_errors":0,"db_errors":0}
SCRIPT="""
local n=redis.call('INCR',KEYS[1])
if n==1 then redis.call('EXPIRE',KEYS[1],ARGV[1]) end
return n
"""
@asynccontextmanager
async def lifespan(app):
    for attempt in range(30):
        try:
            with psycopg.connect(dsn) as conn:
                conn.execute("CREATE TABLE IF NOT EXISTS incidents "
                             "(id text PRIMARY KEY,status text NOT NULL)")
                conn.execute("INSERT INTO incidents VALUES "
                             "('INC-2048','investigating') "
                             "ON CONFLICT (id) DO NOTHING")
            break
        except psycopg.OperationalError:
            if attempt==29:raise
            time.sleep(1)
    yield
app=FastAPI(lifespan=lifespan)
@app.get("/health")
def health():return {"status":"ok"}
@app.get("/metrics")
def metrics():return dict(stats)
@app.get("/incidents/{incident_id}")
def incident(incident_id:str,x_lab_tenant:str|None=Header(default=None)):
    # This caller-controlled header is NOT production authentication.
    if x_lab_tenant not in ("alpha","beta"):
        raise HTTPException(401,"X-Lab-Tenant must be alpha or beta")
    limit=3 if x_lab_tenant=="alpha" else 5
    window=int(time.time())//10
    if os.getenv("LIMITER_ENABLED","0")=="1":
        try:
            count=redis_client.eval(SCRIPT,1,f"quota:{x_lab_tenant}:{window}",11)
        except RedisError as exc:
            stats["redis_errors"]+=1
            log.error("limiter_unavailable tenant=%s error=%s",
                      x_lab_tenant,type(exc).__name__)
            raise HTTPException(503,"limiter unavailable (fail closed)")
        if count>limit:
            stats["rejected"]+=1
            retry=max(1,10-int(time.time())%10)
            raise HTTPException(429,"tenant quota exceeded",
                                headers={"Retry-After":str(retry)})
    stats["allowed"]+=1
    try:
        with psycopg.connect(dsn,connect_timeout=1) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT id,status FROM incidents WHERE id=%s",
                            (incident_id,))
                row=cur.fetchone()
                cur.execute("SELECT pg_sleep(0.15)")
    except psycopg.Error as exc:
        stats["db_errors"]+=1
        log.error("db_error tenant=%s type=%s",x_lab_tenant,type(exc).__name__)
        raise HTTPException(503,"database unavailable")
    if row is None:raise HTTPException(404,"incident not found")
    return {"incident_id":row[0],"status":row[1],"tenant":x_lab_tenant,
            "limiter_enabled":os.getenv("LIMITER_ENABLED","0")=="1"}
~~~

**File: nginx/default.conf**

~~~nginx
log_format lab '$time_iso8601 status=$status request_time=$request_time upstream_time=$upstream_response_time';
server {
 listen 80;
 access_log /var/log/nginx/access.log lab;
 location / {
  proxy_pass http://api:8000;
  proxy_set_header Host $host;
  proxy_set_header X-Lab-Tenant $http_x_lab_tenant;
  proxy_connect_timeout 1s;
  proxy_read_timeout 3s;
 }
}
~~~

**File: compose.yaml**

~~~yaml
services:
  gateway:
    image: nginx:1.27-alpine
    ports: ["127.0.0.1:18010:80"]
    volumes: ["./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro"]
    depends_on: [api]
  api:
    build: .
    environment:
      DATABASE_URL: postgresql://lab:lab@db:5432/lab
      LIMITER_ENABLED: "0"
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: lab
      POSTGRES_PASSWORD: lab
      POSTGRES_DB: lab
    healthcheck:
      test: ["CMD-SHELL","pg_isready -U lab -d lab"]
      interval: 2s
      timeout: 2s
      retries: 20
    volumes: ["lesson10_db:/var/lib/postgresql/data"]
  redis:
    image: redis:7-alpine
    command: ["redis-server","--save","","--appendonly","no"]
volumes:
  lesson10_db:
~~~

**File: tests/test_contract.py**

~~~python
from fastapi.testclient import TestClient
from app.main import app
def test_health():
    with TestClient(app) as c:
        assert c.get("/health").status_code==200
def test_missing_tenant():
    with TestClient(app) as c:
        assert c.get("/incidents/INC-2048").status_code==401
def test_unknown_tenant():
    with TestClient(app) as c:
        assert c.get("/incidents/INC-2048",
                     headers={"X-Lab-Tenant":"other"}).status_code==401
~~~

**BUILD — Baseline**

~~~bash
docker compose -p archlab10 up -d --build
docker compose -p archlab10 ps
docker compose -p archlab10 exec api python -m pytest -q tests
curl -i -H 'X-Lab-Tenant: beta' http://127.0.0.1:18010/incidents/INC-2048
curl -i http://127.0.0.1:18010/health
~~~

Expected: three tests pass; beta 200 with investigating status; health 200. If startup races return 502, inspect gateway/api/db logs and retry when ready.

**BREAK 1 — Alpha burst without protection**

~~~bash
seq 1 20 | xargs -P 10 -I '{}' \
 curl -s -o /dev/null -w 'alpha status=%{http_code} total=%{time_total}s\n' \
 -H 'X-Lab-Tenant: alpha' http://127.0.0.1:18010/incidents/INC-2048
~~~

In a second terminal **during** the burst, request beta and record latency. Without a limiter alpha is admitted; exact latency varies. This small synthetic burst may not cause 504 and must not be presented as proof of the hypothetical 4,000-RPS incident.

**INVESTIGATE**

~~~bash
docker compose -p archlab10 logs --tail=30 gateway api db
docker compose -p archlab10 exec db psql -U lab -d lab -c \
 "SELECT state,wait_event_type,wait_event,count(*) FROM pg_stat_activity GROUP BY 1,2,3;"
docker compose -p archlab10 exec api python -c \
 'import httpx;print(httpx.get("http://127.0.0.1:8000/metrics").json())'
~~~

Observe allowed requests and DB sessions. PostgreSQL pg_sleep holds a connection for 150 ms. A snapshot taken after the burst may miss the peak. This lab opens new DB connections per request; Lesson 07 covers SQLAlchemy pool checkout.

**FIX — Enable shared Redis quota:** Change the api environment LIMITER_ENABLED value from "0" to "1" in compose.yaml, then:

~~~bash
docker compose -p archlab10 up -d --force-recreate api
docker compose -p archlab10 exec redis redis-cli FLUSHDB
for i in 1 2 3 4 5 6; do
 curl -s -o /dev/null -w "alpha request=$i status=%{http_code}\n" \
 -H 'X-Lab-Tenant: alpha' http://127.0.0.1:18010/incidents/INC-2048
done
curl -i -H 'X-Lab-Tenant: beta' http://127.0.0.1:18010/incidents/INC-2048
~~~

Expected: if the six requests fall inside one 10-second window, alpha gets three 200s then three 429s with Retry-After; beta remains 200. Window crossings may change counts. FLUSHDB is safe **only on this dedicated disposable Redis**, never a shared instance.

**BREAK 2 — Redis outage, independently**

~~~bash
docker compose -p archlab10 stop redis
curl -i -H 'X-Lab-Tenant: beta' http://127.0.0.1:18010/incidents/INC-2048
docker compose -p archlab10 logs --tail=20 api
~~~

Expected: HTTP 503 and limiter_unavailable log, while PostgreSQL remains healthy. This is an intentional fail-closed policy.

**FIX / VALIDATE**

~~~bash
docker compose -p archlab10 start redis
docker compose -p archlab10 exec redis redis-cli PING
curl -i -H 'X-Lab-Tenant: beta' http://127.0.0.1:18010/incidents/INC-2048
docker compose -p archlab10 exec api python -m pytest -q tests
docker compose -p archlab10 exec api python -c \
 'import httpx;print(httpx.get("http://127.0.0.1:8000/metrics").json())'
~~~

Expected: PONG, beta 200, three passing tests and meaningful counters. In-process metrics reset on API recreation and are not durable.

**Safe cleanup:** Run docker compose -p archlab10 down. This stops only this project and preserves its named PostgreSQL volume and all unrelated resources. Do not use down -v or volume prune casually.

**Evidence journal:** baseline, alpha burst, beta latency, NGINX/API/DB evidence, alpha 429, Redis 503, recovered beta 200, tests, remaining design limitations. Execute one step, share output, then proceed to the next fault.

## My Architecture Review — Solutions & Doubts

### 1. My Understanding
_Explain shared resource contention and tenant isolation._

### 2. My Solutions to the Architect Challenges
_Answer all three with calculations, alternatives and reasoning._

### 3. My Troubleshooting Approach
_Commands, evidence, hypotheses and falsified alternatives._

### 4. My Proposed Architecture Improvements
_Identity, quotas, DB bulkheads, observability and rollback._

### 5. My Doubts / Questions
_What is unclear and how could it be tested?_

### 6. Lessons Learned
_What would you do differently as an architect?_

### 7. Mentor Review
_Pending user answers and verified lab evidence. Published is not completed._
