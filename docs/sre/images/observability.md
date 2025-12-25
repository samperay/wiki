
## Observability Overview

Metrics + logging + traces
(what)  + (How)   + (where)

- Assume unknown failures
- Enable unexecpted questions
- Understand behaviours, not just health

![observability_overview](./images/observability_overview.png)

Structured logging benefits

- Machine parsable for analysis
- Consistent fields across services
- Rich context for debugging
- Correleation with traces and metrics

## Data source and visualization 

![observability_flow](./images/observability_flow.png)

Grafana data source configuration 

![grafana_data_source_config](./images/grafana_data_source_config.png)

Laws of SRE Dashboard

![sre_dashboard](./images/sre_dashboard.png)

level 1 - service health overview(is everything OK?)
level 2 - service performance details (investigate trends and issues)


Chart types

**Time series**

Best chart - line chart 
use case - request rates, latency, error rates
why - shows trends and spikes

**Status/health**

best chart - stat panel 
use case - service health, SLO's 
why - immediate visual stats

**Distribution data**

best chart - heatmap/histogram 
use case - response time 
why - reveals user experiance 

**Comparative data**

best chart - bar chart
use case - error rate by service 
why - easy comparision 

Dashboard creation 

![dashboard_creation](./images/dashboard_creation.png)

## Alert design and implementation

Alerting principles

![effective_alerts](./images/effective_alerts.png)

- SLO based alerting 
- Error budget alerting
- ALert routing strategy
- time based routing

## performnce monitoring

![performance_reliabiulity_matrix](./images/performance_reliabiulity_matrix.png)

Essential performance metrics

![perf_hierarchy_metrics](./images/perf_hierarchy_metrics.png)

common bottlenecks

![common_bottle_necks](./images/common_bottle_necks.png)

identify where the bottleneck

![common_bottle_necks_solutions](./images/common_bottle_necks_solutions.png)

## Advance visualization

Despite single system, the dashboards needs to be different for different people. 

![dashboards_views](./images/dashboards_views.png)

Rules for dashboard 

![engineer_dashboard_do_donts](./images/engineer_dashboard_do_donts.png)

![executive_dashboard_do_donts](./images/executive_dashboard_do_donts.png)