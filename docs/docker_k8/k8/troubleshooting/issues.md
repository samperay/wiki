## Image pull error 

- incorrect image
- incorect image tags
- incorrect secrets

## Crashing pods

CrashLoopBackOff means Kubernetes is persistently trying to restart a failing container. 
it restarts bcoz of the pod definition file has `restartPolicy: Always`. It can also be set as `never` or `on failure`

- not providing ENV variable it can be `secrets` or `configmaps`
- permission issues for the image while starting up app by scripts.
- missing file/volume for applications/pod
- Memory limits - OOOMKilled.
- liveness or rediness probes endpoint

## pending pods

- insufficient cpu
- taints on the node
- node selector or missing labels 
- missing toleration on nodes

## missing pods

- resource quota on your namespace
- necessary resource accounts or dependencies on your namespace

Always, check the events i.e `kubectl get events -n <namespace>`

## Schrödinger's Deployment

Always use **unique labels** in the deployment when created would get the same match for the pods/services, to forward traffic to the cluster nodes.
Overlapping selectors can cause **unexpected behavior and intermittent failures** that are challenging to diagnose in large-scale environments

## Create container error


### CreateContainerConfigError
- missing env/configmaps/secrets etc 
- env varaible refereced being missed. 

### CreateContainerError
- this happens during the start of container when you have no rntry point defined in the image 

### runtimeContainer
- invalid command 

## Config out of date. 

configuration changes (such as updates to ConfigMaps or Secrets) are not immediately reflected in running pods
Once you change any config maps or secrets make sure you restart deployment as good practice.
```kubectl rollout restart deploymnet <deployment-name>```

Note: you can use a reloader by adding annotating in the deployment file which will restart the pods.

## endless termination 

sometimes a resource may not terminate correctly. Some pods remain in the Terminating state. This behavior is often due to background operations or cleanup tasks (similar to garbage collection) that must complete before the resource is fully removed.

```kubectl delete pod shipping-api-57cdd984bc-grq7g --force```


Removing Finalizers - Finalizers ensure that specific cleanup tasks—such as persistent volume or namespace protection actions—are completed before the resource is deleted

To allow the pod to be fully deleted, remove or set the finalizers to null and save the changes.

## enableServiceLinks

enableServiceLinks is crucial for controlling how service-related environment variables are injected into your pods

**standard_init_linux.go:228: exec user process caused: argument list too long**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-frontend
  namespace: staging
  annotations:
    deployment.kubernetes.io/revision: "1"
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"name":"app-frontend","namespace":"staging"},"spec":{"replicas":1,"selector":{"matchLabels":{"app":"frontend"}},"template":{"metadata":{"labels":{"app":"frontend"}},"spec":{"containers":[{"image":"nginx:1.19","name":"app-frontend","ports":[{"containerPort":80}]}]}}}}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      enableServiceLinks: false <=======
      containers:
        - image: nginx:1.19
          name: app-frontend
          ports:
            - containerPort: 80
```

enableServiceLinks controls how Kubernetes injects service environment variables into your pods. By setting enableServiceLinks to false, you can improve resource efficiency and avoid errors like "argument list too long," especially when many services coexist in the same namespace. Leveraging DNS via CoreDNS for service discovery is a best practice that renders these environment variables unnecessary.

