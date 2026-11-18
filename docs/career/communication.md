
## Comminication template

1. Problem Statement
2. System Context / Architecture
3. How the Technology Works
4. Design Decisions / Tradeoffs
5. Implementation Example
6. Observability / Monitoring
7. Challenges Faced
8. Results / Impact
9. Key Takeaways

`Context → Problem → Approach → Implementation → Result → Lessons`


| Step	    | What to Explain	| Why | 
| --- | --- | --- |
| Context	| What system or environment	| Gives background | 
| Problem	| What issue existed	| Creates importance | 
| Approach	| How you decided to solve it	| Shows thinking | 
| Implementation	| What you built	| Shows technical skill | 
| Result	| What improved	| Shows impact | 
| Lessons	| What you learned	| Shows maturity | 

e.g

Context: "In our operations team we were handling incidents through ServiceNow manually, and most of the tasks were done through multiple systems like Slack, ServiceNow and GitHub."

Problem: "Creating and managing incidents manually was taking around 3 minutes per incident, and during critical incidents we also had to manually create Slack war rooms and onboard users."

Approach: "To reduce the manual operational effort we decided to build an automation platform integrated with Slack so engineers could trigger workflows directly from Slack."

Implementation: "We developed a Slack bot using Python Flask which uses slash commands and modal forms to collect user input.
The bot integrates with ServiceNow APIs for incident management, GitHub APIs for repository actions, and also automates war-room creation."

architecture

```
Slack
  ↓
Slackbot (Flask API)
  ↓
ServiceNow API
  ↓
GitHub API
  ↓
Sysdig API
```

Result: "This automation reduced incident creation time from 3 minutes to about 20 seconds and war-room setup from 5 minutes to about 30 seconds."

Lessons: "One key challenge we faced was handling Slack rate limits and managing concurrent requests. To address this we implemented retry logic and structured background tasks."

**Another way**

`What → Why → How → Trade-offs`

What: "We implemented Kubernetes HPA."

Why : "Because traffic spikes caused pod saturation."

How : "HPA monitors CPU metrics through the metrics server and adjusts replicas dynamically."

Trade-offs : "However HPA depends on correct CPU requests; if misconfigured scaling can behave incorrectly."

