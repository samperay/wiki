# Networking Learning Progress

> Publication status and hands-on completion are **different**. The pages below are written, but no hands-on completion is assumed.

| Topic | Documentation | Lab status | Evidence / notes |
| --- | --- | --- | --- |
| DNS resolution | Published in Phase 1 branch | Not yet verified | |
| TCP connection lifecycle | Published in Phase 1 branch | Not yet verified | |
| Connection failure diagnosis | Published in Phase 1 branch | Not yet verified | |
| Packet capture analysis | Published in Phase 1 branch | Not yet verified | |

## Phase 2 — Documentation published, practice pending

| Lab | Documentation | Hands-on status | Evidence |
| --- | --- | --- | --- |
| [Linux namespaces and routing](labs/linux-routing-namespaces.md) | Published in Phase 2 branch | Not yet verified | |
| [Docker bridge DNS and port publishing](labs/docker-bridge-dns-port-publishing.md) | Published in Phase 2 branch | Not yet verified | |
| [Kubernetes Service, DNS and NetworkPolicy](labs/kubernetes-service-dns-networkpolicy.md) | Published in Phase 2 branch | Not yet verified | |

## Phase 3 — Backend performance (documentation published, labs unverified)

| Topic | Documentation | Practice |
| --- | --- | --- |
| [Keepalive, pooling and timeouts](performance/keepalive-pooling-timeouts.md) | Published in Phase 3 branch | Not yet verified |
| [TCP flow and congestion control](performance/flow-congestion-control.md) | Published in Phase 3 branch | Not yet verified |
| [Packet loss and tail latency](performance/packet-loss-tail-latency.md) | Published in Phase 3 branch | Not yet verified |
| [Bandwidth–delay product](performance/latency-bandwidth-bdp.md) | Published in Phase 3 branch | Not yet verified |
| [Connection limits and capacity](performance/connection-capacity.md) | Published in Phase 3 branch | Not yet verified |
| [Backend timeout and p99 lab](labs/backend-timeouts-p99-capacity.md) | Published in Phase 3 branch | Not yet verified |

## My lab record template

Copy this block under the lesson you actually practiced.

```markdown
### YYYY-MM-DD — Topic
- Environment: Mac / Ubuntu VM / Docker Desktop
- Baseline command and output:
- Failure injected:
- Initial hypothesis:
- Evidence (DNS / socket / capture / logs):
- Root cause:
- Fix and verification:
- Cleanup completed:
- Production architecture lesson:
- Doubts / follow-up:
```

## Skill checkpoints

- [ ] Explain why `dig` and an application can resolve differently.
- [ ] Distinguish SYN timeout, refused connection, and established-session reset.
- [ ] Explain TCP TIME_WAIT without treating it as a bug.
- [ ] Identify where to capture packets and what that vantage point can prove.
- [ ] Diagnose an API from DNS through TLS and HTTP without guessing.
- [ ] Explain when an observed symptom is insufficient to identify the root cause.

[Back to networking hub](index.md)
