# Daily Architecture Incident Lab

A daily **20–25-minute** system design and production SRE troubleshooting learning journal, progressing from fundamentals to distributed systems and platform architecture.

## Learning approach

**Understand → Quantify → Design → Challenge → Observe → Diagnose → Improve → Validate**

Each lesson contains a realistic design problem, requirements, capacity estimation, incremental Mermaid architecture diagrams, a clearly marked simulated incident, investigation commands and evidence, architectural trade-offs, independent challenges, and an optional lab.

## Lessons

| Lesson | Topic | Document |
|---|---|---|
| 01 | System Design Thinking & URL Shortener Reliability | [Lesson 01](lesson-01-system-design-thinking.md) |
| 02 | Reliable Notification System — Queues, Retries & Duplicates | [Lesson 02](lesson-02-reliable-notification-system.md) |

See [Learning Progress](learning.md) for reading status, solutions, and mentor reviews.

## How to use this journal

1. Read a lesson and inspect the Mermaid diagrams.
2. Answer the three architect challenges **before** reading external solutions.
3. Fill out **My Architecture Review — Solutions & Doubts** at the end of the lesson.
4. Commit the updated lesson to this Wiki and share the GitHub link for feedback.
5. Record verified learning progress in `learning.md`.

## Related references

- [System Design Framework](../framework.md)
- [System Design Components](../components.md)
- [Existing URL Shortener Case Study](../app/url_shortner.md)
- [SRE Observability](../../sre/observability.md)
- [Hands-on implementation repository](https://github.com/samperay/sre-devops-architecture-labs)

**Repository boundary:** This Wiki is the knowledge base and design journal. The separate architecture-labs repository holds executable code, tests, infrastructure configuration, and evidence from experiments. Link to labs instead of duplicating them.
