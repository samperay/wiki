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

