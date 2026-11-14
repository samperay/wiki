# Daily Architecture Lab — Learning Progress

> **Progress is evidence-based.** Publication means the lesson exists in GitHub; it does **not** mean it has been read, its challenges answered, or its hands-on lab verified.

[Browse all lessons](index.md)

## Lesson tracker

| Lesson | Topic | Published | Read / understood | Challenges answered | Mentor review | Lab / evidence |
|---|---|---|---|---|---|---|
| [01](lesson-01-system-design-thinking.md) | System Design Thinking & URL Shortener Reliability | Yes | Not confirmed | Not confirmed | Pending | Not confirmed |
| [02](lesson-02-reliable-notification-system.md) | Reliable Notification System — Sync vs Async, Queues, Retries & Duplicates | Yes | Not confirmed | Not confirmed | Pending | Not confirmed |
| [03](lesson-03-delivery-guarantees-idempotency-outbox.md) | Delivery Guarantees, Idempotency & Transactional Outbox | Yes | Not confirmed | Not confirmed | Pending | Not confirmed |
| [04](lesson-04-queue-backpressure-retry-storm.md) | Queue Backpressure, Retry Storms & Recovery Capacity | Yes | Not confirmed | Not confirmed | Pending | Not confirmed |
| [05](lesson-05-api-gateway-cascading-failures-circuit-breakers.md) | API Gateway Cascading Failures & Circuit Breakers | Yes | Not confirmed | Not confirmed | Pending | Not confirmed |
| [06](lesson-06-service-discovery-dns-failures.md) | Service Discovery, DNS Caching & Partial Outages | Yes | Not confirmed | Not confirmed | Pending | Not confirmed |
| [07](lesson-07-database-connection-pool-exhaustion.md) | Database Connection Pool Exhaustion & Admission Control | Yes | Not confirmed | Not confirmed | Pending | Not confirmed |
| [08](lesson-08-zero-downtime-database-schema-migrations.md) | Zero-Downtime Database Schema Migrations & Deployment Compatibility | Yes | Not confirmed | Not confirmed | Pending | Not confirmed |
| [09](lesson-09-leader-election-fencing-scheduled-jobs.md) | Leader Election, Split-Brain Schedulers & Fencing Tokens | Yes | Not confirmed | Not confirmed | Pending | Not confirmed |

**Status note (14 November 2026):** Nine Markdown lessons are published on the `master` branch; publication does not verify local execution. Completion and review statuses remain unconfirmed until you record evidence. “Not confirmed” does not mean you have not done the work.

## Progress criteria

- **Published:** The full Markdown lesson is committed and linked in `mkdocs.yml`.
- **Read / understood:** You can explain the problem, architecture, capacity assumptions, and tradeoffs in your own words.
- **Challenges answered:** All three architect challenges have answers **and reasoning** under the lesson's review section.
- **Mentor reviewed:** Feedback and corrections are recorded in `### 7. Mentor Review`.
- **Lab verified:** Build, baseline, controlled break, investigation, repair, and test evidence are recorded with relevant commit or PR links. Practical Labs are optional and remain **Not confirmed** until executed.

## Practical Labs progress

**LEARN → DESIGN → BUILD → BREAK → INVESTIGATE → FIX → VALIDATE**

Lessons 01–09 include complete local FastAPI-based experiments embedded in their Markdown files. These are **published instructions, not verified local executions**. Use Mac Docker Desktop or Ubuntu VM according to each lesson. Track evidence in the existing **Lab / evidence** column and the review log; do not mark labs complete merely because code was published.

Suggested order: start with [Lesson 01](lesson-01-system-design-thinking.md) to practice the seven-stage workflow, then progress to service failures (05–06) and database failures (07–08).

## Current learning focus

- **Latest published:** [Lesson 09 — Leader Election, Leases & Fencing Tokens](lesson-09-leader-election-fencing-scheduled-jobs.md).
- **Suggested next step:** Work through Lesson 07's global connection-budget calculation and distinguish pool checkout wait from SQL execution and lock wait.
- **Upcoming:** New production architecture scenarios will extend the progression without repeating prior lessons.

## Review log

Add a row when you complete or review a lesson; do not fill in outcomes without evidence.

| Date | Lesson | Main insight | Doubt / gap | Next action | Evidence link |
|---|---|---|---|---|---|
| YYYY-MM-DD | [Lesson NN](index.md) | _Your finding_ | _Your question_ | _Your next step_ | _GitHub commit / lab evidence_ |

## My learning goals

- [ ] Explain architecture choices using measurable requirements and failure domains.
- [ ] Calculate throughput, storage, latency, concurrency, and backlog-recovery budgets.
- [ ] Investigate failures using logs, metrics, traces, and falsifiable hypotheses.
- [ ] Distinguish an incident trigger, technical root cause, and systemic design weakness.
- [ ] Justify resilience mechanisms with explicit operational costs and tradeoffs.
- [ ] Communicate architecture decisions clearly using diagrams and concise design reviews.

## Reference links

- [Daily Architecture Lab overview](index.md)
- [Lesson 01 — System Design Thinking & URL Shortener Reliability](lesson-01-system-design-thinking.md)
- [Lesson 02 — Reliable Notification System — Sync vs Async, Queues, Retries & Duplicates](lesson-02-reliable-notification-system.md)
- [Lesson 03 — Delivery Guarantees, Idempotency & Transactional Outbox](lesson-03-delivery-guarantees-idempotency-outbox.md)
- [Lesson 04 — Queue Backpressure, Retry Storms & Recovery Capacity](lesson-04-queue-backpressure-retry-storm.md)
- [Lesson 05 — API Gateway Cascading Failures & Circuit Breakers](lesson-05-api-gateway-cascading-failures-circuit-breakers.md)
- [Lesson 06 — Service Discovery, DNS Caching & Partial Outages](lesson-06-service-discovery-dns-failures.md)
- [Lesson 07 — Database Connection Pool Exhaustion & Admission Control](lesson-07-database-connection-pool-exhaustion.md)
- [Lesson 08 — Zero-Downtime Database Schema Migrations & Deployment Compatibility](lesson-08-zero-downtime-database-schema-migrations.md)
- [Lesson 09 — Leader Election, Leases & Fencing Tokens](lesson-09-leader-election-fencing-scheduled-jobs.md)
- [Hands-on architecture labs](https://github.com/samperay/sre-devops-architecture-labs)
