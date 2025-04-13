

| # | Interview Question | Explanation / Answer |
|---|--------------------|-----------------------|
| 1 | What is Argo CD and how does it fit into GitOps? | Argo CD automates Kubernetes deployments using Git as the source of truth. It enables GitOps by syncing Git state with live cluster state. |
| 2 | How does Argo CD differ from Flux CD? | Argo CD has a GUI, built-in RBAC, and better multi-cluster support. Flux is more CLI/operator-focused. |
| 3 | How do you manage secrets in Argo CD? | Use tools like SOPS, Sealed Secrets, or External Secrets Operator. Avoid committing raw secrets to Git. |
| 4 | Difference between Manual and Auto Sync? | Manual sync requires user action. Auto sync applies changes from Git to the cluster automatically. |
| 5 | How do you promote code from dev → stage → prod in Argo CD? | Use Git branches, kustomize overlays, or Helm values per environment. Trigger promotion by merging branches. |
| 6 | What are ApplicationSets in Argo CD? | A controller that dynamically generates Argo Applications using templates and generators (Git, Matrix, List, etc.). |
| 7 | How to implement RBAC and security best practices? | Integrate with SSO, disable admin user, restrict resource access via RBAC, use NetworkPolicies. |
| 8 | How is drift detection handled? | Argo CD continuously checks live vs. Git state. Drift shows as `OutOfSync`. Can use `syncOptions` to fine-tune sync behavior. |
| 9 | How do you rollback in Argo CD? | Use `argocd app history` and `argocd app rollback` to revert to a previous revision. |
| 10 | How to monitor and audit Argo CD? | Integrate Prometheus/Grafana, export logs, and use Argo CD audit logs or webhook notifications. |

## real time issues

| # | Issue | Root Cause | Solution / Fix |
|---|-------|------------|----------------|
| 1 | App stuck in OutOfSync due to Helm/Kustomize | Rendering failed (missing values or wrong base) | Validate with `helm template`, ensure `valuesFiles` or `kustomize.path` is correct. |
| 2 | Sync fails due to RBAC or NetworkPolicy | Insufficient permissions or blocked API access | Grant proper ClusterRoleBinding, fix NetworkPolicy, test with `kubectl auth can-i`. |
| 3 | Shared resource (e.g. Secret) is deleted during sync | Prune deletes resources not scoped properly | Use `Prune=false` or resource customizations in Argo CD config. |
| 4 | Excess Applications created by ApplicationSet | Wrong generator or repo structure | Use `preview` mode, validate Git paths, check controller logs. |
| 5 | Application stuck in Syncing state | Failed pre/post sync hook or finalizer | Check `sync hooks`, use retries, patch finalizers if needed. |
| 6 | Resource sync fails due to CRDs not installed yet | CRDs are missing in cluster | Install CRDs first or use `--validate=false` option in sync. |
| 7 | Secrets in Git exposed accidentally | Raw secrets committed to Git | Use encryption tools (SOPS), or external secret backends. |
| 8 | Multi-team setup with config drift | Teams override shared manifests | Use separate overlays per team/environment. Implement strict review via PRs. |
| 9 | UI shows stale sync status | Controller not updated or cache issue | Restart `argocd-application-controller`, refresh app. |
| 10 | Argo CD performance drops in large clusters | High app count, long sync intervals | Scale controller, increase cache size, split by project or namespace. |
