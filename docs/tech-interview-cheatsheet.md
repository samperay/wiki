## Universal Technical Answer Cheat Sheet

**Chain of thought**

1️⃣ Define the concept

2️⃣ Explain the key components

3️⃣ Give a practical example

4️⃣ Mention trade-offs / best practices

### Concept Questions Template

Template

**Definition** First explain what it is.

**How it works** Explain main components or mechanism.

**Example** Give a real-world example.

**Best practice** Mention how it is used in production.

**e.g**

Terraform state is a file that keeps 
track of infrastructure resources created by Terraform.

It maps the Terraform configuration to real infrastructure so Terraform 
can determine what needs to be CRUD.

In team environments, the state file is usually stored in a remote backend 
such as S3 with DynamoDB locking to avoid concurrent modifications.

Best practice is to enable versioning and encryption for the state file since it may contain sensitive data.

---

### Troubleshooting Q Template

Step 1 – Understand the scope

confirm the impact and scope of the issue.

Step 2 – Check system health

Then I check CPU, memory, disk I/O, network latency, and application metrics.

Step 3 – Identify root cause

I analyze logs, dependency latency, database performance, or external APIs.

Step 4 – Mitigation

Once identified, I mitigate by scaling, rolling back, restarting services, or fixing configuration.

**e.g**

**API latency increased**

First I verify the scope and check monitoring dashboards to confirm latency increase.

Then I examine system metrics such as CPU, memory, disk I/O, and network latency.

Next I analyze application logs and dependency latency such as database or external API calls.

Based on findings, I mitigate by scaling the service, rolling back recent deployments, or fixing the underlying bottleneck.

---

### Architecture Q Template

**Problem**  What problem were you solving?

**Components** What systems or services were involved?

**Request flow** How does data move through the system?

**Reliability & scaling** How does the system handle failures or load?

**e.g**

We built an internal Slack automation platform to reduce operational toil and automate incident workflows.

The architecture consists of Slack as the client interface, a Flask-based backend service, and integrations with systems such as ServiceNow and GitHub.

When a user triggers a Slack command, the request is sent to the backend service which processes the input and executes the required workflow.

The application runs on IBM Code Engine with horizontal scaling, and asynchronous processing is used to handle long-running tasks and avoid Slack timeout issues.

---

### Reliability / SRE Questions Template

**Problem** Explain the reliability issue.

**Cause** Why it happens.

**Solution** How SRE practices solve it.

---

### Magic Phrases

“At a high level…”

“There are three main components…”

“From a reliability perspective…”

“The main trade-off is…”

“In production environments…”


## MyQs

### About(yourself) 

Hi, I’m Sunil. I currently work at IBM as part of the SRE automation team, where I focus on building and enhancing internal platform tooling. One of my key contributions has been designing and developing a Slack-based automation system that reduces operational toil by automating incident workflows, war-room creation, and GitHub integrations.

Prior to this, I worked extensively in DevOps roles managing AWS infrastructure and designing CI/CD pipelines using tools like Terraform, Jenkins, and GitHub Actions.

Earlier in my career, I spent several years as a Linux systems administrator, managing large-scale virtualized environments and troubleshooting performance and infrastructure-level issues. That foundation in Linux internals and system behavior has been extremely valuable in my SRE work.

Overall, my experience combines platform automation, cloud infrastructure, and deep Linux fundamentals, with a strong focus on improving reliability and reducing operational overhead.

### Architecture questions(slackbot)

The internal automation platform is designed as a Slack-driven workflow automation system that integrates with multiple operational tools.

At a high level, the architecture consists of three main components:
Slack as the client interface, a backend automation service built using Flask, and integrations with external systems like ServiceNow, GitHub, and Slack war-room management APIs.

When a user triggers a slash command or action from Slack, the request is sent to our Flask-based backend service via Slack’s API gateway. The Flask application processes the request and dynamically generates Slack modals or forms to collect required inputs from the user.

Once the form is submitted, the backend service validates the input and triggers the required workflow — for example creating incidents in ServiceNow, executing GitHub operations, or creating war rooms. The results are then sent back to Slack using Slack API responses.

The application itself is containerized using Docker and deployed on IBM Cloud Code Engine, which allows the service to scale automatically based on incoming requests.

One of the key failure points we identified was Slack’s request timeout window, so for longer operations we decouple the request processing using asynchronous handling to ensure Slack receives an immediate response while the backend processes the task in the background.

From a scalability perspective, the stateless Flask service allows horizontal scaling through the container platform, and we rely on centralized logging and monitoring to track failures and system health.

### troubleshooting

A production service suddenly becomes very slow.Users report requests taking 10–15 seconds instead of 200ms. How would you troubleshoot this?


First I confirm the scope and impact: is the slowness affecting all users or only a subset, and did it start after a deployment, config change, or traffic spike.

Then I check the Golden Signals: latency, error rate, traffic, and saturation. Since latency increased from 200ms to 10–15 seconds, I look at dashboards for request latency percentiles (p95/p99), throughput, and error rate to see if this is a systemic overload or a dependency issue.

Next I isolate whether the bottleneck is in the application or downstream dependencies. I check:

CPU and load average to see if the service is CPU bound

Memory usage and OOM / swapping to see if we have memory pressure

Disk I/O wait to detect storage bottlenecks

In parallel I check service logs and traces (if available) for slow endpoints or repeated retries/timeouts.

If CPU or traffic is the issue, I’ll immediately mitigate by scaling horizontally or increasing replicas, and if it started after a release I consider rollback.

If the bottleneck looks like a downstream dependency (database latency, DNS issues, network timeouts), I focus on that component—checking DB metrics, connection pool saturation, and network health.

Throughout, I keep changes minimal and reversible, and once stability is restored, I document findings and trigger a follow-up RCA.

### Oncall 

During on-call, you get an alert: “Error rate jumped to 15% for the API service.”
You have 5 minutes before leadership pings you.

If the API error rate suddenly jumps to 15%, the first thing I do is quickly assess the scope and impact using monitoring dashboards. I check which endpoints are failing, whether the error rate is increasing across all instances, and whether there was a recent deployment or configuration change.

Within the first couple of minutes, I look at key metrics such as latency, traffic, and saturation to understand if this is due to overload or a dependency failure. I also check application logs to identify common error patterns and determine whether the issue is coming from the API service itself or from an upstream or downstream dependency such as a database or external service.

Once I identify the likely cause, I immediately think about mitigation steps. For example, if the issue started after a deployment, I would consider rolling back. If the service is overloaded, I would scale the service horizontally. If a downstream dependency is failing, I may temporarily disable that functionality or apply rate limiting to protect the system.

At the same time, I communicate the status in the incident channel so stakeholders know that the issue is being investigated and mitigation is in progress. Once the system is stabilized, we proceed with a deeper root cause analysis.

### Architecture

Your internal Slack automation platform suddenly becomes very popular and starts receiving 10x more requests.

How would you redesign or improve the architecture to handle that scale reliably?

If the Slack automation platform receives 10x traffic, the first step is to confirm whether we’re bottlenecked on the API layer, the background processing, or downstream systems like ServiceNow/GitHub.

Architecturally, I’d make sure the system follows an ack-fast + async processing model. Slack requires quick responses, so we immediately acknowledge the request and push the work into a queue for background workers.

For scale, the Flask service remains stateless, so Code Engine can scale it horizontally. For the workers, I’d scale them independently based on queue depth and processing time.

To maintain reliability at higher load, I’d add:

Rate limiting per user/workspace to prevent bursts and protect downstream systems

Idempotency keys so repeated submissions don’t create duplicate incidents or GitHub actions

Retries with exponential backoff for transient errors, and circuit breakers if an external system is unhealthy

Timeouts and concurrency limits per integration to avoid thread exhaustion and cascading failures

Finally, I’d strengthen observability: dashboards for request latency, queue backlog, success/failure rates, and clear alerts, plus defining SLOs like “99% requests acknowledged within 2 seconds” and “workflow success rate above X%”.

That way we scale safely without overloading external dependencies and we maintain a good user experience in Slack.

### SRE/terraform

You provision infrastructure using Terraform. How do you manage Terraform state safely in a team?

To manage Terraform safely in a team, I always use a remote backend so state is centralized and consistent. In AWS, that typically means storing state in an S3 bucket with encryption enabled, and using DynamoDB for state locking to prevent concurrent applies. If we use Terraform Cloud, locking and versioning are handled by the platform.

For environment separation, I prefer separate state per environment—either separate backend prefixes/buckets or separate workspaces—so dev/stage/prod are isolated and we reduce blast radius. For larger systems, we also split state by domain or stack (network, compute, database) rather than one huge state file.

In terms of risks: state can be corrupted, accidentally deleted, or drift can occur if changes are made outside Terraform. To prevent this, I enforce:

least-privilege IAM access to the state bucket

bucket versioning + MFA delete (where applicable)

CI/CD-controlled applies with approvals for production

and regular drift detection / plan checks in pipelines

This ensures consistent collaboration, prevents state conflicts, and keeps environments stable.

### SLI/SLO

Explain the difference between SLI, SLO, and SLA.

Then, for an API service, give:
2 good SLI / 1 realistic SLO and how you’d alert on it (high level)

SLI (Service Level Indicator) is a metric that measures some aspect of system performance, such as request latency, error rate, or availability.

SLO (Service Level Objective) is the target value or threshold defined for that metric. For example, we may define that 99.9% of requests must complete successfully within a given time window.

SLA (Service Level Agreement) is a contractual agreement with customers that defines the expected service level and potential penalties if those levels are not met.

For an API service, two good SLIs would be:

Request latency (for example p95 latency)

Error rate (percentage of failed requests)

A realistic SLO example could be:

99.9% of API requests should respond successfully within 500ms over a rolling 30-day window.

To monitor this, we would collect metrics using systems like Prometheus, visualize them in Grafana dashboards, and configure alerts when the error rate or latency exceeds thresholds that threaten the SLO. Those alerts can be integrated with incident tools like PagerDuty or Slack notifications for on-call engineers.

### alert fatigue

What is alert fatigue and how do you reduce it in an SRE environment?

Alert fatigue occurs when engineers receive too many alerts, especially low-priority or noisy alerts, which eventually leads to important alerts being ignored. This is a common problem in large systems with poorly configured monitoring.

It is usually caused by alerts based on internal metrics rather than user impact, overly sensitive thresholds, duplicate alerts from multiple instances, or alerts that do not require immediate action.

To reduce alert fatigue, we focus on designing actionable alerts. One approach is to align alerts with SLOs, so we only trigger alerts when service reliability is actually at risk. We also group duplicate alerts using tools like Prometheus Alertmanager to reduce noise.

Another important practice is defining clear alert severity levels, so only critical alerts trigger on-call pages while lower-priority alerts go to dashboards or Slack notifications. Additionally, automation and self-healing mechanisms can resolve some issues without requiring human intervention.

These practices significantly improve the signal-to-noise ratio and help SRE teams focus on real incidents.