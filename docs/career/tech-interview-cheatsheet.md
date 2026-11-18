## Universal Technical Answer Cheat Sheet

## TL;DR

Strong technical interview answers are structured, specific, and production-aware. A good answer usually defines the concept, explains how it works, gives a concrete example, and then discusses trade-offs, failure modes, or best practices. For SRE/DevOps interviews, always connect the topic back to reliability, automation, observability, scale, and operational safety.

Use this file as a speaking guide, not a script to memorize word-for-word. The goal is to sound clear, senior, and practical.

## Universal Answer Structure

1. Define the concept.
2. Explain the key components or flow.
3. Give a practical example.
4. Mention trade-offs, failure modes, or best practices.
5. Close with how you would operate it in production.

### Concept Questions Template

**Definition:** Start with what it is in one or two sentences.

**How it works:** Explain the main mechanism, components, or lifecycle.

**Example:** Give a real-world example from cloud, Kubernetes, Terraform, CI/CD, observability, or incident response.

**Best practice:** Mention how it is used safely in production.

**Example: Terraform state**

Terraform state is a file that tracks infrastructure resources managed by Terraform. It maps Terraform configuration to real cloud resources so Terraform can determine what needs to be created, updated, or deleted.

In a team environment, state should be stored in a remote backend such as S3 with DynamoDB locking, or Terraform Cloud, so multiple engineers do not apply changes against separate local state files.

The main risk is that state may contain sensitive values and is critical to Terraform’s view of infrastructure. Best practice is to enable encryption, versioning, least-privilege access, locking, and CI/CD-controlled applies for production.

---

### Troubleshooting Q Template

**Step 1: Understand scope**

Confirm who is impacted, what changed, when it started, and whether this is user-visible.

**Step 2: Check system health**

Check the golden signals: latency, traffic, errors, and saturation. Then inspect CPU, memory, disk I/O, network, application metrics, and dependency health.

**Step 3: Isolate root cause**

Use logs, traces, dashboards, recent deploys, dependency metrics, database performance, and external API status to narrow the failing layer.

**Step 4: Mitigate first**

Restore service quickly with a safe and reversible action: rollback, scale out, fail over, disable a feature, restart a bad instance, or reduce load.

**Step 5: Follow up**

After mitigation, document the incident, complete RCA, and add monitoring, tests, or automation to prevent recurrence.

**Example: API latency increased**

First, I verify the scope and confirm the latency increase in monitoring dashboards. I check whether this affects all users, one region, one endpoint, or one dependency.

Then I inspect golden signals: p95/p99 latency, traffic, error rate, and saturation. In parallel, I check CPU, memory, disk I/O, network latency, and container or host-level resource pressure.

Next, I use logs and traces to identify whether the delay is inside the service or in a downstream dependency such as a database, cache, DNS lookup, or external API.

For mitigation, if the issue started after a release, I roll back. If the service is overloaded, I scale horizontally. If a dependency is slow, I reduce concurrency, enable fallback behavior, or temporarily disable the affected path while communicating status.

---

### Architecture Q Template

**Problem:** What problem were you solving?

**Components:** What systems or services were involved?

**Request flow:** How does data move through the system?

**Reliability and scaling:** How does it handle failures, retries, timeouts, backpressure, and load?

**Operations:** How do you deploy, monitor, alert, and debug it?

**Example**

We built an internal Slack automation platform to reduce operational toil and automate incident workflows.

At a high level, the architecture has Slack as the user interface, a Flask backend service for request handling, and integrations with ServiceNow, GitHub, and Slack war-room APIs.

When a user triggers a Slack command, Slack sends the request to the backend. The backend validates the request, acknowledges Slack quickly, and then processes longer workflows asynchronously so we do not hit Slack timeout limits.

The service runs as a stateless container on IBM Cloud Code Engine, so it can scale horizontally. Reliability is improved with retries, idempotency, timeouts, logging, metrics, and dashboards for request latency, workflow success rate, and integration failures.

---

### Reliability / SRE Questions Template

**Problem:** Explain the reliability issue and user impact.

**Cause:** Explain why it happens technically.

**SRE approach:** Tie it to SLIs, SLOs, error budgets, alerting, toil reduction, automation, or incident response.

**Mitigation:** Explain what you would do immediately.

**Prevention:** Explain what you would improve later.

---

### Magic Phrases

- “At a high level…”
- “There are three main components…”
- “From a reliability perspective…”
- “The main trade-off is…”
- “In production environments…”
- “The first thing I would verify is…”
- “I would separate mitigation from root cause analysis…”
- “I would make the change small, reversible, and observable…”

## Practice Aloud

Pick one topic and explain it for 60 seconds.

Examples:

- Kubernetes pod lifecycle
- Terraform state
- TCP three-way handshake
- Incident response process
- CI/CD pipeline flow
- SLI, SLO, and error budget
- Nginx reverse proxy
- Database connection pool saturation

### Tips

- Speak as if you are explaining to an interviewer.
- Structure the answer as:
  1. What it is
  2. How it works
  3. Real-world usage
  4. Trade-off or failure mode
- Record yourself if possible and review clarity, pacing, and filler words.
- Prefer short, confident sentences over long answers that wander.

With consistent practice, your explanations will become clearer and more structured within a week.

## MyQs

### About Yourself

Hi, I’m Sunil. I currently work at IBM as part of the SRE automation team, where I focus on building and improving internal platform tooling. One of my key contributions has been designing and developing a Slack-based automation platform that reduces operational toil by automating incident workflows, war-room creation, and GitHub integrations.

Before this, I worked in DevOps roles managing AWS infrastructure and designing CI/CD pipelines with tools like Terraform, Jenkins, and GitHub Actions.

Earlier in my career, I spent several years as a Linux systems administrator, managing virtualized environments and troubleshooting performance and infrastructure-level issues. That Linux foundation has been extremely valuable in my SRE work because it helps me reason about systems from the OS layer up to the application.

Overall, my experience combines platform automation, cloud infrastructure, CI/CD, and deep Linux fundamentals, with a strong focus on improving reliability and reducing operational overhead.

### Architecture Questions: Slackbot

The internal automation platform is designed as a Slack-driven workflow automation system that integrates with multiple operational tools.

At a high level, the architecture has three main components: Slack as the client interface, a Flask-based backend automation service, and integrations with systems like ServiceNow, GitHub, and Slack war-room APIs.

When a user triggers a slash command or action from Slack, Slack sends the request to our Flask backend. The backend validates the request and dynamically generates Slack modals or forms to collect required inputs.

Once the form is submitted, the backend validates the payload and triggers the required workflow. For example, it may create an incident in ServiceNow, execute a GitHub operation, or create a Slack war room. The result is sent back to Slack through Slack API responses.

The application is containerized with Docker and deployed on IBM Cloud Code Engine, which allows the stateless service to scale based on incoming requests.

One key design consideration is Slack’s request timeout window. For longer operations, we use an ack-fast and async-processing model: Slack receives an immediate acknowledgement, while backend workers process the task in the background.

From a reliability perspective, I would include idempotency keys, retries with backoff, timeouts, integration-specific circuit breakers, structured logging, metrics, and dashboards for workflow success rate, queue depth, latency, and failures.

### Troubleshooting

Question: A production service suddenly becomes very slow. Users report requests taking 10-15 seconds instead of 200ms. How would you troubleshoot this?

First, I confirm the scope and impact. I check whether slowness affects all users or only a subset, and whether it started after a deployment, configuration change, traffic spike, or dependency incident.

Then I check the golden signals: latency, error rate, traffic, and saturation. Since latency increased from 200ms to 10-15 seconds, I look at p95 and p99 latency, throughput, and error rate to understand whether this is systemic overload or isolated to a route or dependency.

Next, I isolate the bottleneck. I check CPU and load average for CPU saturation, memory and OOM events for memory pressure, disk I/O wait for storage bottlenecks, and network latency for connectivity issues.

In parallel, I check logs and traces for slow endpoints, repeated retries, timeout errors, database query latency, cache misses, or external API slowness.

If the issue started after a release, I consider rollback. If the service is overloaded, I scale horizontally. If a downstream dependency is slow, I check connection pool saturation, database health, DNS/network behavior, and whether we can apply fallback, rate limiting, or circuit breaking.

Throughout the incident, I keep mitigation small and reversible. After stability is restored, I document the timeline, root cause, and follow-up actions.

### Oncall

Question: During on-call, you get an alert: “Error rate jumped to 15% for the API service.” You have 5 minutes before leadership pings you.

If the API error rate jumps to 15%, I first assess scope and impact from dashboards. I check which endpoints are failing, whether failures affect all instances or a subset, and whether there was a recent deployment or config change.

Within the first few minutes, I inspect latency, traffic, error rate, and saturation. I also check application logs for common error signatures and compare upstream and downstream dependency health.

Then I focus on mitigation. If the issue started after a deployment, I roll back. If the service is overloaded, I scale out or reduce traffic. If a dependency is failing, I may temporarily disable that feature, apply rate limiting, or fail over if supported.

At the same time, I communicate in the incident channel with a short update: what is impacted, what I am checking, and what mitigation is in progress. Leadership does not need root cause in five minutes; they need confidence that impact is understood and mitigation is moving.

After the service stabilizes, I continue with deeper RCA and follow-up prevention work.

### Architecture: 10x Slackbot Traffic

Question: Your internal Slack automation platform suddenly becomes very popular and starts receiving 10x more requests. How would you redesign or improve the architecture to handle that scale reliably?

First, I identify the bottleneck: API request handling, background processing, queue depth, database/state storage, or downstream systems like ServiceNow and GitHub.

Architecturally, I would make sure the platform follows an ack-fast and async-processing model. Slack requires quick responses, so the API layer should immediately acknowledge the request and enqueue work for background processing.

The Flask service should remain stateless so Code Engine can scale it horizontally. Workers should scale independently based on queue depth, workflow duration, and downstream rate limits.

To maintain reliability at higher load, I would add rate limiting per user or workspace, idempotency keys to avoid duplicate incidents or GitHub actions, retries with exponential backoff, circuit breakers for unhealthy integrations, and timeouts/concurrency limits per downstream system.

I would also strengthen observability with dashboards for request latency, queue backlog, workflow success/failure rate, integration latency, and error budget burn. Example SLOs could be “99% of Slack requests acknowledged within 2 seconds” and “99.5% of workflows complete successfully within 5 minutes.”

This approach scales safely without overloading external dependencies and preserves a good user experience in Slack.

### SRE/Terraform

Question: You provision infrastructure using Terraform. How do you manage Terraform state safely in a team?

To manage Terraform state safely in a team, I use a remote backend so state is centralized and consistent. In AWS, that usually means S3 for state storage with encryption and versioning, plus DynamoDB for state locking. Terraform Cloud can also handle remote state, locking, and collaboration workflows.

For environment separation, I prefer separate state per environment using backend prefixes, separate buckets, or workspaces depending on team standards. For larger platforms, I also split state by domain, such as network, compute, database, and Kubernetes, to reduce blast radius and improve apply times.

The main risks are state corruption, accidental deletion, secret exposure, concurrent applies, and drift from manual changes. To reduce those risks, I enforce least-privilege IAM access, bucket versioning, encryption, locking, CI/CD-controlled applies, production approvals, and regular drift detection.

This keeps team collaboration safe and makes infrastructure changes auditable, reversible, and predictable.

### SLI/SLO

Question: Explain the difference between SLI, SLO, and SLA. Then, for an API service, give two good SLIs, one realistic SLO, and how you would alert on it at a high level.

An SLI, or Service Level Indicator, is a metric that measures user-visible service behavior. Examples include request success rate, latency, availability, or freshness.

An SLO, or Service Level Objective, is the target for that metric over a defined window. For example, 99.9% of API requests should succeed over 30 days.

An SLA, or Service Level Agreement, is a contractual commitment to customers. It may include penalties or credits if the provider fails to meet the agreed service level.

For an API service, two good SLIs are:

- Request success rate, measured as successful requests divided by total valid requests.
- Request latency, such as the percentage of requests completed under 500ms.

A realistic SLO could be: 99.9% of valid API requests should complete successfully and 95% should complete under 500ms over a rolling 30-day window.

For alerting, I would avoid paging only on raw CPU or instance-level symptoms. I would alert on error budget burn: for example, fast-burn alerts for severe user impact over a short window and slow-burn alerts when the service is gradually consuming its error budget. Dashboards in Prometheus/Grafana and notifications through PagerDuty or Slack would support investigation.

### Alert Fatigue

Question: What is alert fatigue and how do you reduce it in an SRE environment?

Alert fatigue happens when engineers receive too many alerts, especially alerts that are noisy, low priority, duplicate, or not actionable. Over time, this causes important alerts to be ignored or handled slowly.

It is usually caused by alerts on internal symptoms rather than user impact, overly sensitive thresholds, duplicate alerts from many instances, missing routing rules, and alerts that do not require immediate human action.

To reduce alert fatigue, I design actionable alerts tied to user impact and SLOs. A page should mean a human needs to act now. Lower-priority signals can go to dashboards, tickets, or Slack channels.

I also group and deduplicate alerts using tools like Alertmanager, define clear severity levels, add runbooks, tune thresholds based on history, and remove alerts that never lead to action.

Automation and self-healing can also reduce pages for known issues. The overall goal is to improve signal-to-noise ratio so on-call engineers focus on real incidents.

## Quick 60-Second Answer Patterns

### CI/CD Pipeline

A CI/CD pipeline automates how code moves from commit to production. At a high level, CI validates the change with tests, linting, security scans, and build steps, while CD deploys the artifact to environments in a controlled way.

In production, I would include approvals for sensitive environments, automated rollback, deployment strategies like blue/green or canary, and observability after deployment. The main trade-off is speed versus control: faster deployments reduce lead time, but production needs guardrails to reduce blast radius.

### Kubernetes Pod Lifecycle

A Kubernetes pod is the smallest deployable unit in Kubernetes. The lifecycle starts when the scheduler places the pod on a node, then the kubelet pulls images, starts containers, runs probes, and reports status back to the API server.

From a reliability perspective, readiness probes control whether traffic should reach the pod, while liveness probes can restart unhealthy containers. Common failure points include image pull errors, bad config, failing probes, resource pressure, and crash loops.

### TCP Three-Way Handshake

The TCP three-way handshake establishes a reliable connection before data transfer. The client sends SYN, the server replies with SYN-ACK, and the client responds with ACK.

In production troubleshooting, handshake failures can indicate firewall issues, security group problems, port not listening, SYN backlog saturation, or network path issues. I would verify with tools like `ss`, `tcpdump`, `nc`, and load balancer target health.

## Common Pitfalls

- Giving a definition-only answer with no production example.
- Jumping to root cause before explaining how you would confirm impact.
- Forgetting mitigation in troubleshooting answers.
- Overusing tool names without explaining the system behavior.
- Treating SLOs as simple threshold alerts instead of error-budget-based reliability targets.
- Describing architecture without failure modes, scaling, or observability.

## Key Takeaways

Interview answers should be structured, practical, and operationally grounded. Define the topic, explain the flow, give an example, and mention trade-offs or production best practices.

For SRE/DevOps roles, the strongest answers connect technology to reliability: how it fails, how you detect it, how you mitigate it, and how you prevent repeat incidents.
