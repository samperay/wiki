## production readiness

real readiness meaning 

- ready for real users
- withstand real load
- handles real problems
- avoids costly failures

![non_negotiable_readiness](./images/non_negotiable_readiness.png)

![pre_launch_rediness](./images/pre_launch_rediness.png)

![questions_for_new_services](./images/questions_for_new_services.png)

Observability .. 

Metrics: is it slow ?

logs: why is it slow ?

traces: where is the slow ?

**Readiness Questions:**

- would your service be healthy in 30 seconds ?
- Can you identigy problem in 5 minutes ?
- Can you wake up the right person automatically ?


# Configuration Management

![config_mgmt_pitfalls](./images/config_mgmt_pitfalls.png)

Overcome these pitfalls 

- Env promotion

![env_promotion](./images/env_promotion.png)

- Create env specific configs

env.dev.properties
env.stage.properties
env.prod.properties

## Secure software releases

![sre_security](./images/sre_security.png)

![common_security_issues](./images/common_security_issues.png)

![security_cicd_verification](./images/security_cicd_verification.png)

![security_best_practices](./images/security_best_practices.png)

![secure_pipeline](./images/secure_pipeline.png)

Security scanning

- Token auth 
- Automated scanning
- SBOM tracking
- leaast privilege
- environment controls 
- container scanning

## release engineering best practices

Deployment strategies

![deployment_strategies](./images/deployment_strategies.png)

why do you need artifact ?

![artifact_matters](./images/artifact_matters.png)

CICD plan

![cicd_plan](./images/cicd_plan.png)

CICD best practices

![cicd_practices](./images/cicd_practices.png)

Communication and learning

![communication_release](./images/communication_release.png)