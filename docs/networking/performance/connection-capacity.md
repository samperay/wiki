# Connection Limits and Backend Capacity

**Goal:** Diagnose overload at socket, file descriptor, accept queue, ephemeral port, connection tracking, pool and application layers without confusing them.

## LEARN — Capacity is a chain of limits

```mermaid
flowchart LR
    C["Clients"] --> P["Proxy / LB connection cap"]
    P --> L["Listen + accept queue"]
    L --> F["Process file descriptors"]
    F --> W["Worker concurrency"]
    W --> D["Downstream pool / DB"]
```

A service can accept TCP connections while being unable to process requests quickly. Increasing one limit can move the bottleneck elsewhere.

| Limit | Typical evidence | Common mistake |
| --- | --- | --- |
| Process file descriptors | `ulimit -n`, process fd count, EMFILE | Raising OS limit without checking leaks |
| Listen/accept backlog | `ss -lnt`, kernel counters | Assuming SYN backlog and accept queue are identical |
| Client ephemeral ports | `ip_local_port_range`, connection tuples | Treating TIME_WAIT alone as exhaustion |
| NAT conntrack | `nf_conntrack_count/max` where available | Blaming app worker pool for NAT state exhaustion |
| Proxy upstream connections | Nginx metrics/logs | Confusing active connections with request concurrency |
| App worker/thread pool | Queue wait, busy workers, latency | Adding workers beyond CPU/memory budget |
| DB connection pool | Acquire wait, DB max connections | Increasing pool without DB capacity |

## DESIGN — Little's Law as a sizing aid

For a stable system, **average concurrency ≈ arrival rate × average time in system**. At 200 requests/s and 0.25 s average service time, approximately **50 requests** are in flight. At 1.5 s under overload, approximately **300** are in flight if the arrival rate stays constant. This is not a safe pool-size prescription: account for bursts, percentiles, queueing and resource constraints.

## BUILD — Read-only Linux capacity inspection

Run on your Ubuntu VM; these commands inspect state and do not change kernel configuration.

```bash
ulimit -n
ss -s
ss -lnt
cat /proc/sys/net/ipv4/ip_local_port_range
cat /proc/sys/net/core/somaxconn
cat /proc/sys/net/ipv4/tcp_max_syn_backlog
python3 - <<'PY'
for rate, seconds in [(200, .25), (200, 1.5)]:
    print(f"{rate} rps x {seconds}s = {rate * seconds:.0f} in-flight requests (average)")
PY
```

**Expected:** limits and socket summary vary by OS/kernel; the calculation prints 50 and 300. On macOS, Linux `/proc` paths are absent—use the Ubuntu VM for this exercise.

## BREAK — Controlled queueing simulation

Run this **local simulation**, not a production load test:

```python
from concurrent.futures import ThreadPoolExecutor
from threading import BoundedSemaphore
from time import monotonic, sleep

slots = BoundedSemaphore(2)
def work(i):
    start = monotonic()
    if not slots.acquire(timeout=0.1):
        return i, "REJECTED", round(monotonic()-start, 3)
    try:
        sleep(0.3)
        return i, "SERVED", round(monotonic()-start, 3)
    finally:
        slots.release()

with ThreadPoolExecutor(max_workers=6) as pool:
    print(list(pool.map(work, range(6))))
```

**Expected:** some requests rejected by the semaphore; exact ordering varies. This demonstrates **application admission capacity**, not Linux TCP backlog behavior.

## INVESTIGATE — Find the first saturated boundary

1. Separate connection attempts, established connections and successful requests.
2. Measure queue wait and rejected/timeout counts per boundary.
3. Check file descriptors and process limits before increasing worker count.
4. Correlate CPU, memory, socket state, proxy upstream and database connection metrics.
5. Identify whether overload is local to a node, one backend, a NAT gateway or the whole region.
6. Prove mitigation with throughput, error rate, p99 latency and resource headroom.

## OPERATE

Use bounded queues, load shedding, per-destination concurrency, and deliberate retry budgets. Reserve capacity for health and control traffic. Do not tune kernel settings blindly; test under controlled, representative load.

Related: [keepalive and pooling](keepalive-pooling-timeouts.md), [SRE observability](../../sre/observability.md).

## My Architecture Review — Solutions & Doubts

- Why can raising `ulimit -n` fail to improve throughput?
- What happens to in-flight concurrency when latency increases at constant RPS?
- **My measurements / doubts:**
