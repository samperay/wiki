## Deployments

- Deploy multiple instances of your application (like a web server) to ensure high availability and load balancing.
- Seamlessly perform rolling updates for Docker images so that instances update gradually, reducing downtime.
- Quickly roll back to a previous version if an upgrade fails unexpectedly.
- Pause and resume deployments, allowing you to implement coordinated changes such as scaling, version updates, or resource modifications.

`kubectl create deployment --image=nginx nginxdeployment --replicas=2`

When you create a deployment, Kubernetes automatically creates an associated ReplicaSet.

```yaml
kubectl get rs
kubectl describe rs <>
```

## Pods

With Kubernetes, the goal is to run containers on worker nodes, but rather than deploying containers directly, Kubernetes encapsulates them within an object called a pod. A pod represents a single instance of an application and is the smallest deployable unit in Kubernetes.

### Deploy pods

```yaml
kubectl run nginx --image=nginx
kubectl get pods -o wide
```

## Replication Set
Replica Set ensures that a specified number of pod replicas are running at any one time. makes sure that a pod or a homogeneous set of pods is always up and available 
It was earlier used to be called as **replication controller.**

```
kubectl create -f replicaset.yml
kubectl get rs
kubectl describe rs
```

## Services

Kubernetes Services enables communication between various components within an outside of the application.

There are 3 types of service types in kubernetes

- NodePort: A NodePort service maps requests arriving at a designated node port (like 30008) to the Pod’s target port.

+-------------+        NodePort        +--------------------+        Pod
|   Client    | --->  NodeIP:30008 --->| Kubernetes Node    | --->  nginx:80
+-------------+                        +--------------------+      (10.244.x.x)



- ClusterIP: The service creates a Virtual IP inside the cluster to enable communication between different services such as a set of frontend servers to a set of backend 
servers

+-------------------+         Service ClusterIP          +------------------+
| Front-End Service |  --->  10.96.0.15:80  --->         |   Pod: nginx     |
+-------------------+                                    |   10.244.x.x:80  |
                                                         +------------------+


- LoadBalancer: Provisions a load balancer for our application in supported cloud providers.



          Internet
              |
     +----------------+
     | External LB    |
     | 35.201.10.22   |
     +----------------+
              |
         NodePort(s)
              |
+--------------------------+
|  Kubernetes Nodes        |
+--------------------------+
              |
         ClusterIP
              |
         nginx Pod


## Namespace

Namespaces are intended for use in environments with many users spread across multiple teams, or projects. Mainly used for isolation of the resources.
While deployments and ReplicaSets work together seamlessly, deployments provide additional functionalities such as rolling updates, rollbacks, and the ability to pause/resume changes.

When you create a Service, it creates a corresponding DNS entry. This entry is of the form <service-name>.<namespace-name>.svc.cluster.local, which means that if a container just uses <service-name>, it will resolve to the service which is local to a namespace. This is useful for using the same configuration across multiple namespaces such as Development, Staging and Production. If you want to reach across namespaces, you need to use the fully qualified domain name (FQDN).

identify which namespace you need your default namespace to be, then you can set your context accordingly.

```yaml
kubectl config set-context $(kubectl config current-context) --namespace=default
kubectl config set-context $(kubectl config current-context) --namespace=dev
```

if you need to limit the resources based on the namespace...

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: dev
spec:
  hard:
    pods: "10"
    requests.cpu: "4"
    requests.memory: 5Gi
    limits.cpu: "10"
    limits.memory: 10Gi
```