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


### pod scheduler 

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
  nodeName: node01
```

### taint and tolerations

```yaml

kubectl taint node node01 node-role.kubernetes.io/control-plane:NoSchedule
kubectl taint node node01 node-role.kubernetes.io/control-plane:NoSchedule-


kubectl taint node node02 spray=mortein:NoSchedule # imperative method

# pod definition using declarative method.
tolerations:
  - key: spray
    value: mortein
    effect: NoSchedule
    operator: Equal
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


## labels and selectors

```yaml
kubectl get pods -l app=nginx
kubectl get pods -l app=nginx tier=frontend
kubectl get all -l app=nginx tier=frontend
```

## cmd and args

```yaml
# command
apiVersion: v1 
kind: Pod 
metadata:
  name: ubuntu-sleeper-2 
spec:
  containers:
  - name: ubuntu
    image: ubuntu
    command:
      - "sleep"
      - "5000"
```

```yaml
# green.yaml
apiVersion: v1 
kind: Pod 
metadata:
  name: webapp-green
  labels:
      name: webapp-green 
spec:
  containers:
  - name: simple-webapp
    image: kodekloud/webapp-color
    command: ["python", "app.py"]
    args: ["--color", "green"] 
```

### Dockerfile and kubernetes args

```Dockerfile
FROM python:3.6-alpine
RUN pip install flask
COPY . /opt/
EXPOSE 8080
WORKDIR /opt
ENTRYPOINT ["python", "app.py"]
CMD ["--color", "red"]
```

```yaml
apiVersion: v1 
kind: Pod 
metadata:
  name: webapp-green
  labels:
      name: webapp-green 
spec:
  containers:
  - name: simple-webapp
    image: kodekloud/webapp-color
    command: ["--color","green"]
```


## env variables

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: webapp-color
  name: webapp-color
  namespace: default
spec:
  containers:
    - name: webapp-color
      image: kodekloud/webapp-color
      env:
        - name: APP_COLOR
          value: green
```


## config maps

kubectl create configmap webapp-color --from-literal=APP_COLOR=darkblue --from-literal=APP_OTHER=green
kubectl create configmap dbconfig --from-file=dbconfig.properties

```yaml
# configmap.yaml
apiVersion: v1
data:
  APP_COLOR: darkblue
  APP_OTHER: green
kind: ConfigMap
metadata:
  name: webapp-color
  namespace: default
```

### configmap into pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: webapp-color
  name: webapp-color
  namespace: default
spec:
  containers:
    - name: webapp-color
      image: kodekloud/webapp-color
      env:
        - name: APP_COLOR
          valueFrom: 
            configMapKeyRef:
              name: webapp-config-map
              key: APP_COLOR
```

## secrets

kubectl create secret generic app-secret  --from-literal=DB_Host=mysql
kubectl create secret generic app-secret --from-file=app_secret.properties

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
data:
  DB_Host: c3FsMDE=
  DB_User: cm9vdA==
  DB_Password: cGFzc3dvcmQxMjM=
```

### inject secrets into pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp-color
  labels:
    name: simple-webapp-color
spec:
  containers:
  - name: simple-webapp-color
    image: simple-webapp-color
    ports:
    - containerPort: 8080
    envFrom:
    - secretRef:
        name: db-secret
```