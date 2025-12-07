## Chaos engineering

instead of measuring, failing, and fixing, what if we simulate all these ?

- Create failures
- Find weakness
- fix proactively

intentionally introduce system failure
identify vulnerable before users raise issues

Chaos engg - shows your system works under real world chaos

**Resiliebce testing**

- kill a pod and verify failover works
- disconnect db to check fallback
- simulate latency to test timeout

**chaos engineering**

- Introduce network paritions during peak traffic 
- Memory pressure with database slowdown
- Multiple small failures cascading into big ones

Safe Chaos experiments in stages

![choas_experiments](./images/choas_experiments.png)

![choas_experiments_1](./images/choas_experiments_1.png)

![choas_experiments_2](./images/choas_experiments_2.png)

Chaos key insights

![chaos_key_insights](./images/chaos_key_insights.png)

Chaos principles

![chaos_principles](./images/chaos_principles.png)

Chaos maturity model 

![chaos_maturity_model](./images/chaos_maturity_model.png)

## cost of realibility

Cost efficiency and realibility

if SLO wants to move from 99.9 to 99.99%, the cost would be 100x more than current. find the below reasons 
i.e if SLO is stricter, the more budget goes into reliability

![reliability_cost](./images/reliability_cost.png)

Autoscaling strategies

![autoscaling_strategies](./images/autoscaling_strategies.png)

SLO budget framework

![slo_budget_framework](./images/slo_budget_framework.png)

why does SLO budget matters ?

![slo_budget_matter](./images/slo_budget_matter.png)