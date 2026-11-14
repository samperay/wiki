# Daily Architecture Incident Lab

A growing **20–25-minute guided system-design and production SRE troubleshooting journal** for an experienced Python/Linux DevOps/SRE engineer progressing toward system and platform architecture.

> **Publication status:** Lessons 01–09 are available in this Wiki. A published lesson is not necessarily read, practiced, or mentor-reviewed.

## Learning method

**LEARN → DESIGN → BUILD → BREAK → INVESTIGATE → FIX → VALIDATE**

Each lesson starts with design first principles and includes a realistic problem, functional and nonfunctional requirements, capacity calculations, incremental GitHub-compatible Mermaid diagrams, technology tradeoffs, failure modes, a **clearly labeled hypothetical incident**, chronological investigation with realistic evidence and commands, root cause versus architectural weakness, mitigation and redesign, observability, validation, **three independent architect challenges**, and an additional **Practical Labs** section with complete copyable application code, Docker Compose, controlled fault injection, investigation, repair, validation, and cleanup. The original architecture explanations are preserved.

## Browse all lessons

| Lesson | Topic | Open |
|---|---|---|
| 01 | System Design Thinking & URL Shortener Reliability | [Read Lesson 01](lesson-01-system-design-thinking.md) |
| 02 | Reliable Notification System — Sync vs Async, Queues, Retries & Duplicates | [Read Lesson 02](lesson-02-reliable-notification-system.md) |
| 03 | Delivery Guarantees, Idempotency & Transactional Outbox | [Read Lesson 03](lesson-03-delivery-guarantees-idempotency-outbox.md) |
| 04 | Queue Backpressure, Retry Storms & Recovery Capacity | [Read Lesson 04](lesson-04-queue-backpressure-retry-storm.md) |
| 05 | API Gateway Cascading Failures & Circuit Breakers | [Read Lesson 05](lesson-05-api-gateway-cascading-failures-circuit-breakers.md) |
| 06 | Service Discovery, DNS Caching & Partial Outages | [Read Lesson 06](lesson-06-service-discovery-dns-failures.md) |
| 07 | Database Connection Pool Exhaustion & Admission Control | [Read Lesson 07](lesson-07-database-connection-pool-exhaustion.md) |
| 08 | Zero-Downtime Database Schema Migrations & Deployment Compatibility | [Read Lesson 08](lesson-08-zero-downtime-database-schema-migrations.md) |
| 09 | Leader Election, Split-Brain Schedulers & Fencing Tokens | [Read Lesson 09](lesson-09-leader-election-fencing-scheduled-jobs.md) |

[View the learning progress tracker](learning.md){ .md-button }

## Practical Labs — runnable local exercises

Every lesson 01–09 now includes a separate **Practical Labs** section. Choose **Mac Docker Desktop** for multi-container experiments, or an **Ubuntu virtual machine** when resources permit. The lesson itself contains every small source file and command as a labeled Markdown code block: no ZIP archive is required.

1. **LEARN / DESIGN:** Read the architecture, incident analysis, and Mermaid diagrams.
2. **BUILD:** Create the lesson-specific FastAPI application and open-source dependencies from the code blocks.
3. **BREAK:** Introduce one isolated, reversible failure in the disposable Compose project.
4. **INVESTIGATE:** Record logs, response codes, metrics, and your competing hypotheses.
5. **FIX / VALIDATE:** Recover service, rerun tests, and explain the production-grade design improvements.

The 20–25-minute reading lesson is separate from the optional 35–60-minute hands-on lab. Work through lab steps one at a time and record actual evidence. Existing optional exercises remain available.

## Suggested 20–25-minute session

1. **0–4 min — Define the problem:** Identify the users, failure domains, and success criteria.
2. **4–8 min — Quantify and design:** Check load assumptions and evaluate the architecture.
3. **8–17 min — Investigate:** Follow the hypothetical incident timeline, commands, logs, metrics, and traces.
4. **17–21 min — Improve:** Separate immediate mitigation from durable architectural fixes.
5. **21–25 min — Decide:** Answer the three architect challenges independently.

## How to record your learning

1. Open the lesson from the table or the left-hand navigation.
2. Work through the incident without jumping straight to the root cause.
3. Fill in **My Architecture Review — Solutions & Doubts** at the end of the lesson.
4. Commit your answers to the Wiki and share the lesson link for a reasoning-focused review.
5. Update [learning.md](learning.md) **only after verifying** what you actually completed.

## Architecture roadmap

- **01–02 — Foundations:** Requirements, capacity, synchronous versus asynchronous workflows, and queue reliability.
- **03–04 — Messaging resilience:** Outbox, idempotency, delivery guarantees, backpressure, and recovery capacity.
- **05–06 — Synchronous service reliability:** Timeouts, circuit breakers, dependency isolation, service discovery, and DNS caching.
- **07 — Data-layer admission and capacity:** PostgreSQL connection budgets, pool checkout, locks, and safe scaling.
- **08 — Safe schema evolution:** Expand–migrate–contract, mixed-version compatibility, backfill and rollback.
- **09 — Scheduler coordination:** Leader election, leases, fencing tokens and idempotent effects.
- **Future lessons:** Progress to deeper distributed-system and platform design scenarios without repeating completed topics.

## Related knowledge and practical labs

- [System Design Framework](../framework.md)
- [System Design Components](../components.md)
- [URL Shortener Case Study](../app/url_shortner.md)
- [SRE Observability](../../sre/observability.md)
- [Kubernetes Networking](../../docker_k8/k8/networking.md)
- [NGINX Reverse Proxy](../../nginx/reverse_proxy.md)
- [SRE/DevOps Architecture Labs — implementation repository](https://github.com/samperay/sre-devops-architecture-labs)

**Repository boundary:** This Wiki is the reference, design journal, and mentor-review space. Keep larger executable projects and tracked implementation experiments in the separate architecture-labs repository. The Wiki lessons now also include small self-contained copyable practical labs to reproduce each incident locally; link to larger labs when useful.
