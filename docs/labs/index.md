# Labs & Projects

**Choose one small failure to investigate, then record what the evidence proves.** This is a discovery dashboard, not a claim that the labs have been executed.

**LEARN → DESIGN → BUILD → BREAK → INVESTIGATE → FIX → VALIDATE**

## Choose a lab by skill

*Durations are planning estimates, not measured execution times. Allow extra time for installation and debugging. “Published” describes documentation only; practical completion remains unverified until you record outputs.*

| Lab | Skill / failure to investigate | Environment | Level | Optional hands-on estimate | Status |
| --- | --- | --- | --- | --- | --- |
| [Linux namespaces and routing](../networking/labs/linux-routing-namespaces.md) | veth, routes, reachability | Ubuntu VM | Intermediate | 45–75 min | Published; unverified |
| [Docker bridge DNS and published ports](../networking/labs/docker-bridge-dns-port-publishing.md) | Container DNS, isolation, host binding | Mac Docker Desktop | Intermediate | 35–60 min | Published; unverified |
| [Kubernetes Service, DNS and NetworkPolicy](../networking/labs/kubernetes-service-dns-networkpolicy.md) | Pod-to-Service path, DNS, policy | Local Kubernetes | Intermediate–advanced | 60–90 min | Published; unverified |
| [Backend timeouts and p99](../networking/labs/backend-timeouts-p99-capacity.md) | Saturation, tail latency, timeout budgets | Docker Desktop | Advanced | 45–75 min | Published; unverified |
| [Local mTLS identity](../networking/labs/mtls-local-service-identity.md) | Certificate trust and service identity | Local environment per lab | Advanced | 45–90 min | Published; unverified |
| [Daily Architecture Incident Labs](../sysdesign/daily-architecture-lab/index.md) | System design, controlled failures, evidence-led diagnosis | Per lesson | Intermediate–advanced | Per lesson; reading 20–25 min | Published lessons; execution unverified |
| [Kubernetes projects](../docker_k8/k8/k8projects.md) | Larger Kubernetes builds | Local cluster | Varies | Project-dependent | Reference; not assessed |
| [AWS project catalog](../cloud/aws/projects/toc.md) | Cloud and CI/CD builds | AWS | Varies | Project-dependent | Reference; not assessed |

## Pick by today's goal

- **Troubleshoot a network path:** start with [connection failure diagnosis](../networking/troubleshooting/connection-failure-diagnosis.md), then practice the [Docker DNS lab](../networking/labs/docker-bridge-dns-port-publishing.md).
- **Diagnose slow APIs:** review [keepalive, pooling and timeouts](../networking/performance/keepalive-pooling-timeouts.md), then run the [backend p99 lab](../networking/labs/backend-timeouts-p99-capacity.md).
- **Practice architecture judgment:** choose a [Daily Architecture Lab](../sysdesign/daily-architecture-lab/index.md) and answer its three independent design challenges before reading your own troubleshooting evidence.
- **Go deeper into Kubernetes:** review [Kubernetes architecture](../docker_k8/k8/architecture.md) and attempt the [Service/DNS/NetworkPolicy lab](../networking/labs/kubernetes-service-dns-networkpolicy.md).

## Progress and evidence

| Track | Published content and existing progress log | What counts as verified |
| --- | --- | --- |
| Networking & backend | [Networking progress](../networking/learning.md) | Baseline, controlled failure, logs/captures, fix and retest |
| Daily Architecture Lab | [Architecture lesson tracker](../sysdesign/daily-architecture-lab/learning.md) | Architecture answers and actual local test evidence |
| Larger projects | [Kubernetes projects](../docker_k8/k8/k8projects.md) / [AWS projects](../cloud/aws/projects/toc.md) | Working implementation and reproducible validation |

### Copyable lab evidence template

```markdown
### YYYY-MM-DD — Lab title
- Environment and resource limits:
- Baseline command / observed result:
- Failure injected (one at a time):
- Hypothesis:
- Evidence: commands, logs, metrics or packet capture:
- Immediate cause and systemic weakness:
- Repair / rollback:
- Validation output:
- Cleanup and preserved data:
- Architecture trade-off learned:
- Evidence link (commit, PR or notes):
```

**Recommended habit:** Run one step, capture its actual output, explain the observation, and only then inject the next fault. Do not mark a lab complete because the instructions exist.

[Back to the learning homepage](../index.md)
