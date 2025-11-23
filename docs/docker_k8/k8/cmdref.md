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

## Multicontainer pods

### reguler multipod containers
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-redis
  labels:
    name: nginx-redis
spec:
  containers:
      - name: nginx
        image: nginx:latest
      - name: redis
        image: redis
```

### initcontainer

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: initcontainer
  labels:
    name: initcontainer
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

### multi_init

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi_init
  labels:
    name: multi_init
spec:
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

### sidecar

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: app
  name: app
  namespace: elastic-stack
spec:
  initContainers:
  - name: sidecar
    image: kodekloud/filebeat-configured
    restartPolicy: Always
    volumeMounts:
      - name: log-volume
        mountPath: /var/log/event-simulator

  containers:
  - image: kodekloud/event-simulator
    name: app
    resources: {}
    volumeMounts:
    - mountPath: /log
      name: log-volume

  volumes:
  - hostPath:
      path: /var/log/webapp
      type: DirectoryOrCreate
    name: log-volume
```


## flask deployment app

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
      - name: flask
        image: rakshithraka/flask-web-app
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: flask-web-app-service
spec:
  type: ClusterIP
  selector:
    app: flask-app
  ports:
   - port: 80
     targetPort: 80 
```

## HPA

kubectl autoscale deployment nginx-deployment --max=3 --cpu-percent=80
kubectl get hpa
kubectl event hpa


This command configures the "my-app" deployment to maintain 50% CPU utilization, scaling the number of pods between 1 and 10:
kubectl autoscale deployment my-app --cpu-percent=50 --min=1 --max=10

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 7
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
        resources:
         requests: # manual setting hpa limits
           cpu: 100m  
         limits:
           cpu: 200m
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: nginx-deployment
spec:
  minReplicas: 1
  maxReplicas: 3
  metrics:
  - resource:
      name: cpu
      target:
        averageUtilization: 80
        type: Utilization
    type: Resource
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nginx-deployment
status:
  currentMetrics: null
  desiredReplicas: 0
  currentReplicas: 0
```