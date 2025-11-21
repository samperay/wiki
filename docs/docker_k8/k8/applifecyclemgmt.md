# Application Life Cycle Management

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

## Multi Container Pod
There are at times you need to have an container which has two or more services required to be available ( e.g webserver & log agent). They need to co-exists and hence they are create/deleted at the same time. Such cases we are required to have multi container pods. They would share same namespaces, network isolations etc .

There are 3 common patterns, when it comes to designing multi-container PODs. The first and what we just saw with the logging service example is known as a *side car pattern*. The others are the adapter and the ambassador pattern.


```
spec:
  containers:
      - name: nginx
        image: nginx:latest
      - name: redis
        image: redis
```
what incase if you require any container to be run only once in the multi pod container ?
i.e to pull a code or binary from a repository that will be used by the main web application. That is a task that will be run only  one time when the pod is first created. Or a process that waits  for an external service or database to be up before the actual application starts

Those can be configured as *initContainers*.

## initContainers
An initContainer is configured in a pod like all other containers, except that it is specified inside a initContainers section,  like this:

```
spec:
  containers:
  - name: myapp-container
    image: busybox:1.28
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-myservice
    image: busybox
    command: ['sh', '-c', 'git clone <some-repository-that-will-be-used-by-application> ; done;']
```

When a POD is first created the initContainer is run, and the process in the initContainer must run to a completion before the real container hosting the application starts.

You can configure multiple such initContainers as well, like how we did for multi-pod containers. In that case each init container is run one at a time in sequential order.

```
  containers:
  - name: myapp-container
    image: busybox:1.28
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-myservice
    image: busybox:1.28
    command: ['sh', '-c', 'until nslookup myservice; do echo waiting for myservice; sleep 2; done;']
  - name: init-mydb
    image: busybox:1.28
    command: ['sh', '-c', 'until nslookup mydb; do echo waiting for mydb; sleep 2; done;']
```

# Liveness, Readiness, Startup probes

Many applications running for long periods of time eventually transition to broken states, and cannot recover except by being restarted. Kubernetes provides liveness probes to detect and remedy such situations.

kubelet uses readiness probes to know when a container is ready to start accepting traffic. one use of this signal is to control which pods are used as backend for services. when pod is not ready, its removed from service LB. Sometimes, applications are temporarily unable to serve traffic. For example, an application might need to load large data or configuration files during startup, or depend on external services after startup. In such cases, you don't want to kill the application, but you don't want to send it requests either. Kubernetes provides readiness probes to detect and mitigate these situations

kubelet uses startup probes to know when a container application has started. if any such probe is configured, it disables liveness and readiness checks until it succeeds. Sometimes, you have to deal with legacy applications that might require an additional startup time on their first initialization. In such cases, it can be tricky to set up liveness probe parameters without compromising the fast response to deadlocks that motivated such a probe



References:
https://kubernetes.io/docs/tasks/debug-application-cluster/get-shell-running-container/
