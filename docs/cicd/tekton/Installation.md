Tekton is an open-source cloud native CICD (Continuous Integration and Continuous Delivery/Deployment) solution

## installations

Make sure you have any of the tool being installed for the kubernetes cluser. i.e Rancher/Podman/Docker Desktop etc. 

`kind` is a tool for installation local kubernetes cluster. Please install . 

[installing-from-release-binaries](https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries)

Verify cluster is created and working fine. 

```
➜  ~ kind version
kind v0.20.0 go1.20.4 darwin/amd64
➜  ~ kind create cluster --name tekton-cluster
Creating cluster "tekton-cluster" ...
 ✓ Ensuring node image (kindest/node:v1.27.3) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-tekton-cluster"
You can now use your cluster with:

kubectl cluster-info --context kind-tekton-cluster

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
➜  ~ kubectl config current-context
kind-tekton-cluster
➜  ~ kubectl create deployment nginx --image=nginx
deployment.apps/nginx created
```

[install tekton pipelines](https://tekton.dev/docs/installation/pipelines/)

```
➜  ~ kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.52.0/release.yaml
namespace/tekton-pipelines created
clusterrole.rbac.authorization.k8s.io/tekton-pipelines-controller-cluster-access created
clusterrole.rbac.authorization.k8s.io/tekton-pipelines-controller-tenant-access created
clusterrole.rbac.authorization.k8s.io/tekton-pipelines-webhook-cluster-access created
clusterrole.rbac.authorization.k8s.io/tekton-events-controller-cluster-access created
role.rbac.authorization.k8s.io/tekton-pipelines-controller created
role.rbac.authorization.k8s.io/tekton-pipelines-webhook created
role.rbac.authorization.k8s.io/tekton-pipelines-events-controller created
role.rbac.authorization.k8s.io/tekton-pipelines-leader-election created
role.rbac.authorization.k8s.io/tekton-pipelines-info created
serviceaccount/tekton-pipelines-controller created
serviceaccount/tekton-pipelines-webhook created
serviceaccount/tekton-events-controller created
clusterrolebinding.rbac.authorization.k8s.io/tekton-pipelines-controller-cluster-access created
clusterrolebinding.rbac.authorization.k8s.io/tekton-pipelines-controller-tenant-access created
clusterrolebinding.rbac.authorization.k8s.io/tekton-pipelines-webhook-cluster-access created
clusterrolebinding.rbac.authorization.k8s.io/tekton-events-controller-cluster-access created
rolebinding.rbac.authorization.k8s.io/tekton-pipelines-controller created
rolebinding.rbac.authorization.k8s.io/tekton-pipelines-webhook created
rolebinding.rbac.authorization.k8s.io/tekton-pipelines-controller-leaderelection created
rolebinding.rbac.authorization.k8s.io/tekton-pipelines-webhook-leaderelection created
rolebinding.rbac.authorization.k8s.io/tekton-pipelines-info created
rolebinding.rbac.authorization.k8s.io/tekton-pipelines-events-controller created
rolebinding.rbac.authorization.k8s.io/tekton-events-controller-leaderelection created
customresourcedefinition.apiextensions.k8s.io/clustertasks.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/customruns.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/pipelines.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/pipelineruns.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/resolutionrequests.resolution.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/tasks.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/taskruns.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/verificationpolicies.tekton.dev created
secret/webhook-certs created
validatingwebhookconfiguration.admissionregistration.k8s.io/validation.webhook.pipeline.tekton.dev created
mutatingwebhookconfiguration.admissionregistration.k8s.io/webhook.pipeline.tekton.dev created
validatingwebhookconfiguration.admissionregistration.k8s.io/config.webhook.pipeline.tekton.dev created
clusterrole.rbac.authorization.k8s.io/tekton-aggregate-edit created
clusterrole.rbac.authorization.k8s.io/tekton-aggregate-view created
configmap/config-defaults created
configmap/config-events created
configmap/feature-flags created
configmap/pipelines-info created
configmap/config-leader-election created
configmap/config-logging created
configmap/config-observability created
configmap/config-registry-cert created
configmap/config-spire created
configmap/config-tracing created
deployment.apps/tekton-pipelines-controller created
service/tekton-pipelines-controller created
deployment.apps/tekton-events-controller created
service/tekton-events-controller created
namespace/tekton-pipelines-resolvers created
clusterrole.rbac.authorization.k8s.io/tekton-pipelines-resolvers-resolution-request-updates created
role.rbac.authorization.k8s.io/tekton-pipelines-resolvers-namespace-rbac created
serviceaccount/tekton-pipelines-resolvers created
clusterrolebinding.rbac.authorization.k8s.io/tekton-pipelines-resolvers created
rolebinding.rbac.authorization.k8s.io/tekton-pipelines-resolvers-namespace-rbac created
configmap/bundleresolver-config created
configmap/cluster-resolver-config created
configmap/resolvers-feature-flags created
configmap/config-leader-election created
configmap/config-logging created
configmap/config-observability created
configmap/git-resolver-config created
configmap/hubresolver-config created
deployment.apps/tekton-pipelines-remote-resolvers created
service/tekton-pipelines-remote-resolvers created
horizontalpodautoscaler.autoscaling/tekton-pipelines-webhook created
deployment.apps/tekton-pipelines-webhook created
service/tekton-pipelines-webhook created
➜  ~
```

