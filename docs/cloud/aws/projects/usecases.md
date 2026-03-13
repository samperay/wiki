HA Web App — tests knowledge of subnet design (public/private), AZ affinity, RDS failover RTOs, and session persistence with ElastiCache.


![ha_web_app](ha_web_app.png)

Serverless Pipeline — tests EventBridge vs SNS/SQS trade-offs, Lambda concurrency limits, DLQ handling, and cost optimization (pay-per-invocation).


![serverless_pipeline](serverless_pipeline.png)

CI/CD Pipeline — tests rollback strategy (blue/green vs canary), IAM roles for cross-service access, artifact signing, and environment promotion gates.


![cicd_pipeline](cicd_pipeline.png)

ECS Fargate Microservices — tests task definition design, service-level isolation, secret injection via Secrets Manager, and independent scaling policies per service.

![ecs_fargate](ecs_fargate.png)


Data Lake — tests medallion architecture (bronze/silver/gold), columnar format choices (Parquet vs ORC), Glue Crawler scheduling, and Athena vs Redshift cost trade-offs.

![data_lake](data_lake.png)


Transit Gateway Hub-and-Spoke — tests multi-account network design, route table segmentation to prevent dev→prod traffic, and Direct Connect bandwidth planning.

![tgw_hub](tgw_hub.png)


EKS + Karpenter + GitOps — tests node provisioning strategy (Karpenter vs CAS), IRSA for pod-level IAM, and GitOps reconciliation loops with ArgoCD.

![eks_karpenter_gitops](eks_karpenter_gitops.png)

Zero-Trust Security — tests defense-in-depth thinking, the difference between preventive (SCPs, SGs) vs detective (GuardDuty, Config) controls, and data-plane vs control-plane security.

![zero_trust_security](zero_trust_security.png)

Multi-Region DR — tests RPO/RTO trade-off decisions, Aurora Global vs DynamoDB Global Tables, and Route 53 failover policy types (failover vs latency vs health check weighted).

![multi_region_dr](multi_region_dr.png)

Cost Optimization — tests FinOps maturity, Spot interruption handling in batch workloads, and S3 lifecycle policy design for cold data.

![cost_optimization](cost_optimization.png)


SQS Batch Processing — tests visibility timeout tuning, DLQ retry strategies, and queue-depth–driven ASG scaling policies.

![sqs_batch_processing](sqs_batch_processing.png)