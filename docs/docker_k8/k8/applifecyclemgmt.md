# Application Life Cycle Management

Understanding the container lifecycle is crucial ..

1. **Image Pulling** - pulls the container image (e.g., nginx:latest) from the image registry to the node. With correct registry credentials, this step completes successfully
2. **Container Configuration** - creates the container configuration by setting environment variables, command arguments, resource limits, volume mounts, network settings, security contexts..etc (incase failed - **CreateContainerConfigError** )
3. **Container Creation** - The container runtime (e.g., containerd or Docker) creates the container using the pulled image. This involves establishing the filesystem and Linux namespaces. (incase failed - **CreateContainerError**)
4. **Container Start** - the container's process starts by executing the defined command or entry point. Errors occurring at this stage are often referred to as **run container errors**, **signaling problems with the process startup**.


## Rollout and Versioning in a Deployment
when you first create deployment, it will create a rollout which trigger deployment ( e.g v1), future when the application is upgraded meaning when the container version is updated to a new one a new rollout is triggered and a new deployment revision is created named revision (v2). These revisions help you track changes and enable rollbacks to previous versions if issues arise.

Events indicate that the **old ReplicaSet is scaled down to zero before scaling up the new ReplicaSet**.

## Deployment Strategies

There are 2 types of deployment strategies

- Recreate
- RollingUpdate (Default Strategy)

### Recreate
One way to upgrade these to a newer version is to destroy all of these and then create newer versions of application instances meaning **first destroy the running instances and then deploy the new instances of the new application version**.

The problem with this as you can imagine is that during the period after the older versions are down and before any newer version is up the application is down and inaccessible to users this strategy is known as the Recreate strategy.

### RollingUpdate

Instead we take down the older version and bring up a newer version one by one. This way the application never goes down and the upgrade is seamless. In other words rolling update is the default deployment strategy so we talked about upgrades.

How exactly do you update your deployment when you say update.

It could be different things such as updating your application version by updating the version of docker containers used, updating their labels or updating the number of replicas etc. Since we already have a deployment definition file it is easy for us to modify this file once we make the necessary changes.

we run the kubectl apply command to apply the changes. A new rollout is triggered and a new revision after deployment is created.

```yaml
$ kubectl describe deployment nginxdeps
$ kubectl rollout status deployment/nginxdeps
$ kubectl rollout history deployment/nginxdeps
$ kubectl rollout undo deployment/nginxdeps
```

## Configuring Applications

- Configuring Command and Arguments on applications
- Configuring Environment Variables
- Configuring Secrets

### Configuring Command and Arguments on applications

when you specify a command field in the Pod spec, it completely replaces both the Docker ENTRYPOINT and CMD. It doesn't append to or modify the ENTRYPOINT.

[](./cmdref.md#cmd-and-args)

`python app.py --color green` - This would only happen if the Pod used args instead of command. 
`python app.py` - the Pod manifest’s command: ["--color","green"] overrides the Dockerfile’s ENTRYPOINT (python app.py), not just the CMD


### Configure env

To set an environment variable set an *env* property in pod defination file.

There are other ways of setting the environment variables such as,
- ConfigMaps
- Secrets

```
containers:
- name: ubuntu-sleeper
  image: ubuntu-sleeper
  command: ["sleep2.0"]
  args: ["10"]
env:
- name: APP_COLOR
  value: pink
```

## ConfigMaps

There are 2 phases involved in configuring ConfigMaps.

1. create the configMaps

[config_maps](./cmdref.md#config-maps)

2. Inject then into the pod.

[config_maps_pod](./cmdref.md#configmap-into-pod)

## Secrets

How Kubernetes handles secrets ?

- A secret is only sent to a node if a pod on that node requires it.
- Kubelet stores the secret into a tmpfs so that the secret is not written to disk storage.
- Once the Pod that depends on the secret is deleted, kubelet will delete its local copy of the secret data as well.

[secrets](./cmdref.md#secrets)

encoding: echo -n 'mysql' | base64
decoding: echo -n 'bXlzcWw=' | base64 --decode

## MultiContainer Pod
There are at times you need to have an container which has two or more services required to be available ( e.g webserver & log agent). They need to co-exists and hence they are create/deleted at the same time. Such cases we are required to have multi container pods. They would share same namespaces, network isolations etc but we are not sure as to which would start first. 

There are 3 common patterns, when it comes to designing multi-container PODs. 

- **regular co-existing containers** (app and db)

[multicontainerpods](./cmdref.md#reguler-multipod-containers)

- **init containers** (start before main application as helper and dies once done. (api startup or db ready))

[initcontainer](./cmdref.md#initcontainer)

[multi_init_containers](./cmdref.md#multi_init)

- **sidecar containers** (starts before the application and continues to run.(istio, file beat etc))

[sidecar](./cmdref.md#sidecar)


## autoscaling

Two primary scaling strategies in Kubernetes:

- Scaling workloads – adding or removing containers (Pods) in the cluster.
  - **Horizontal scaling**: Create more Pods.
  - **Vertical scaling**: Increase resource limits and requests for existing Pods.

- Scaling the underlying cluster infrastructure – adding or removing nodes (servers) in the cluster.
  - **Horizontal scaling**: Add more nodes to the cluster.
  - **Vertical scaling**: Increase resources (CPU, memory) on existing nodes


### HPA

**Horizontal Pod Autoscalar**

[hpa](./cmdref.md#hpa)

### VPA

**Vertical Pod Autoscalar**

