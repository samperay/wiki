

## SR measures

![sla](./images/sla.png)

![slo](./images/slo.png)

![sli](./images/sli.png)

![sla_sli_slo](./images/sla_sli_slo.png)

![sla_sli_slo_1](./images/sla_sli_slo_1.png)

monitoring tells you if you are healthy

![monitoring](./images/monitoring.png) 

observability tells you why are you sick 

![obsevability](./images/obsevability.png)

There are 3 data types for measuring realibility

**Metrics**

whats happening along....

![sli_metrics](./images/sli_metrics.png)

**Traces**

where it went wrong ..
![sli_traces](./images/sli_traces.png)

**logs**

what went wrong ... 
Details the information for debug and diagonizes the cause for SLO viloations..

![sli_logs](./images/sli_logs.png)

**Golden rules**

![4_golden_rules](./images/4_golden_rules.png)

![monitoring_window](./images/imamonitoring_windowge.png)

![common_pitfalls](./images/common_pitfalls.png)

## Implementing SLIs

![choose_right_sli](./images/choose_right_sli.png)

Once you have identified whats SLI you need, you would choose for the queries to get metrics. 

![choose_slis](./images/choose_slis.png)

### Availability SLI

![availability_sli](./images/availability_sli.png)

![availability_sli_1](./images/availability_sli_1.png)

# 📊 Availability vs Allowed Downtime — Cheat Sheet

## 🔢 Uptime Targets

| Availability | Allowed Downtime per Day | per Week | per Month (30 days) | per Year |
|--------------|--------------------------|----------|----------------------|----------|
| **99% (Two nines)**      | **14m 24s**        | **1h 40m 48s** | **7h 18m**         | **3 days 15h** |
| **99.9% (Three nines)**  | **1m 26s**         | **10m 4s**     | **43m 12s**        | **8h 45m** |
| **99.99% (Four nines)**  | **8.6 seconds**    | **1 minute**   | **4m 32s**         | **52m 34s** |
| **99.999% (Five nines)** | **0.86 seconds**   | **6 seconds**  | **26 seconds**     | **5m 15s** |

---

## 🧮 Formula

Allowed downtime = (1 - Availability%) × Total period
Allowed downtime(99.99%) = (1-99.99%) i.e 0.0001 × (30 days × 24 × 60 minutes) = 4.32 minutes


### Latency SLI

![latency_sli](./images/latency_sli.png)

![latency_sli_1](./images/latency_sli_1.png)

### Error SLI

![error_sli](./images/error_sli.png)

![error_sli_usecases](./images/error_sli_usecases.png)

### Throughput 

![throughput](./images/throughput.png)

![throughput_usecases](./images/throughput_usecases.png)

### Satuaration

![saturation_sli](./images/saturation_sli.png)

![saturation_usecases](./images/saturation_usecases.png)

## SLO Game

![slo_game](./images/slo_game.png)