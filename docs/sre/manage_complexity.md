## System design simplicity

Simplicity is a design goal

One rule of managing complex systems is to ensure they're actually necessary.

Complex systems are:

- Harder to understand 
- Harder to maintain
- prone to undexpected failures

Realibility cost complexity

![cost_complexity](./images/cost_complexity.png)

Reason for increased complexties

![reason_for_complexity](./images/reason_for_complexity.png)

Simplification strategies

![simply_systems](./images/simply_systems.png)

![complexity_justified](./images/complexity_justified.png)

## Managing dependency

![dependency_challange](./images/dependency_challange.png)

![well_managed_deps](./images/well_managed_deps.png)

Dependency types:

- Direct deps - Componet A calls component B
- Indirect deps - Comp A relies on B through intermediary 
- Runtime deps - External services, db and caches
- Build time deps - libs, framework, tools

Blast Radius

measures how widely a failure spead across systems, knowing a components blast radius guides realibility priorities

Factors afftecting blast radius

![blast_radius_factors](./images/blast_radius_factors.png)

![blast_radius_factors_1](./images/blast_radius_factors_1.png)

![deps_classification](./images/deps_classification.png)

![deps_classification_example](./images/deps_classification_example.png)

![circuit_breaker](./images/circuit_breaker.png)

![fall_back_graceful_degradation](./images/fall_back_graceful_degradation.png)

![fall_back_graceful_degradation_1](./images/fall_back_graceful_degradation_1.png)

![bulk_heads](./images/bulk_heads.png)

![bulk_heads_examples](./images/bulk_heads_examples.png)

## Change Management

Common failures 

![chg_failures](./images/chg_failures.png)

SRE needs to balance between **velocity and the stability** for the change. 

small, frequent, validated code changes actually leads to :

- Better learning
- Greater system resilience
- Faster recovery 
- Tighter feedback loops 

![chg_confidence_loop](./images/chg_confidence_loop.png)

Safe deployments strategies

- Blue green deployment
- Canary 
- Feature flags

Monitoring is crtutial during changes after deployments ..

After change request 

Error rate - is it increasing after change ?
latency - us system responding more slowly ?
traffic - are users able to access the service ?
saturation - are resources under pressure ?
Deployment progress - is the chg expected as per plan

Deployment verfiication process

smoke tests - basic functionality checks
integrration tests - validates component interactions
performance tests - verified system performance
canary test - real users test new version
gradual traffic testing - increases traffic with monitoring

## capacity planning

![capacity_planning_intro](./images/capacity_planning_intro.png)

Key components of capacity planning

![capacity_planning_components](./images/capacity_planning_components.png)

Benefits:

- Prevents outages 
- reduce costs by right sizing infra
- supports business growth with adequate capacity
- improves user experiance by maintaining performance 
- enables more predicatable and planning

resource measurement 

![reosurce_measurements](./images/reosurce_measurements.png)

Forecating models

![forecating_models](./images/forecating_models.png)

![proactive_reactive_forecasting](./images/proactive_reactive_forecasting.png)

threshold types

![threshold_types](./images/threshold_types.png)

![setting_thresholds](./images/setting_thresholds.png)

## Managing operation toil

![toil_in_sre](./images/toil_in_sre.png)

![toil_examples](./images/toil_examples.png)

toil impact from enginner presepective

![toil_engineer_impact](./images/toil_engineer_impact.png)

toil impact from Business prespective

![toil_business_impact](./images/toil_business_impact.png)

![toil_measurement_approaches](./images/toil_measurement_approaches.png)

![toil_reduction_methods](./images/toil_reduction_methods.png)

Direct cost

![toil_costs](./images/toil_costs.png)

Indirect costs

![toil_costs_indirect](./images/toil_costs_indirect.png)