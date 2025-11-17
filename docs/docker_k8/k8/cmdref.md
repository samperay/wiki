## imperative commands 

The imperative approach in Kubernetes involves executing specific commands to create, update, or delete objects. This method instructs Kubernetes on both what needs to be done and how it should be done. Use this method for rapid execution when you need to quickly create or modify Kubernetes objects,


```yaml
kubectl run --image=nginx nginx
kubectl create deployment --image=nginx nginx
kubectl expose deployment nginx --port 80
kubectl edit deployment nginx
kubectl scale deployment nginx --replicas=5
kubectl set image deployment nginx nginx=nginx:1.18
kubectl create -f nginx.yaml
kubectl replace -f nginx.yaml
kubectl delete -f nginx.yaml
```

## Declarative

The declarative approach enables you to specify the desired state of your infrastructure through configuration files (typically written in YAML).

This approach is recommended for complex, long-term management scenarios. It enables a systematic management of configurations via YAML files, ensuring every change is recorded and version-controlled.

## pods

kubectl run nginx --dry-run=client --image nginx -o yaml > nginx.yaml
kubectl create service nodeport nginx-service --tcp=80:80 --dry-run=client -o yaml >>nginx.yaml

```yaml
# nginx.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
    app: frontend
  name: nginx-application
spec:
  containers:
  - image: nginx
    name: nginx
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: frontend
    run: nginx
  name: nginx-service
spec:
  ports:
  - name: nginx-port-80
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: frontend
  type: NodePort
```

## Deployment

kubectl create deployment --image=nginx nginxdeployment --replicas=2 --dry-run=client -o yaml > nginxdeps.yaml
kubectl create svc nodeport nginxdeps --tcp=80:80 -o yaml >>nginxdeps.yaml

```yaml
# nginxdeps.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginxdeps
  name: nginxdeps
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginxdeps
  strategy: {}
  template:
    metadata:
      labels:
        app: nginxdeps
    spec:
      containers:
      - image: sunlnx/mac4linux:v1
        name: nginx
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: nginxdeps
  name: nginxdeps
  namespace: default
spec:
  ports:
  - name: 80-80
    port: 80 # virtual port on the service within the cluster
    protocol: TCP
    targetPort: 80 # port on the Pod where the application listens 
    nodePort: 30008 # defined the static nodeport
  selector:
    app: nginxdeps
  type: NodePort # maps the external request to the specific port on the node
```


## Services

                +-----------------------+
                |     Your Browser      |
                +-----------------------+
                          |
                          | 1. Access using Node IP + NodePort
                          v
                http://<Node-IP>:<NodePort>
                          |
                          v
        +-------------------------------------------+
        |              Kubernetes Node              |
        |-------------------------------------------|
        |                                           |
        |   NodePort Service (auto: 30000–32767)    |
        |       Example: NodePort 31333             |
        |                                           |
        +-------------------------------------------+
                          |
                          | 2. NodePort forwards traffic
                          v
        +-------------------------------------------+
        |                Service (ClusterIP)         |
        |-------------------------------------------|
        | Name: nginxdeps                            |
        | port: 80                                   |
        | selector: app=nginxdeps                    |
        +-------------------------------------------+
                          |
                          | 3. Service forwards to pod's targetPort
                          v
        +-------------------------------------------+
        |                  Pod (nginx)              |
        |-------------------------------------------|
        | containerPort / targetPort: 80            |
        | Image: nginx:latest                       |
        +-------------------------------------------+
                          |
                          v
                   nginx serves response