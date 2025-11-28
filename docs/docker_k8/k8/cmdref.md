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

## csr

```yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: akshay
spec:
  groups:
  - system:authenticated
  request: <cat akshay.csr | base64 -w 0>
  usages:
  - client auth
```

```yaml
kubectl get csr 
# akshay would be in pending state. we need to approve it. 

kubectl certificate approve akshay
kubectl certificate deny agent-smith
kubectl delete csr agent-smith
```

## kubeconfig 


```yaml
# kubectl config -h

  current-context   Display the current-context
  delete-cluster    Delete the specified cluster from the kubeconfig
  delete-context    Delete the specified context from the kubeconfig
  delete-user       Delete the specified user from the kubeconfig
  get-clusters      Display clusters defined in the kubeconfig
  get-contexts      Describe one or many contexts
  get-users         Display users defined in the kubeconfig
  rename-context    Rename a context from the kubeconfig file
  set               Set an individual value in a kubeconfig file
  set-cluster       Set a cluster entry in kubeconfig
  set-context       Set a context entry in kubeconfig
  set-credentials   Set a user entry in kubeconfig
  unset             Unset an individual value in a kubeconfig file
  use-context       Set the current-context in a kubeconfig file
  view              Display merged kubeconfig settings or a specified kubeconfig
file
```

```yaml
# /root/my-kube-config
apiVersion: v1
kind: Config

clusters:
- name: production
  cluster:
    certificate-authority: /etc/kubernetes/pki/ca.crt
    server: https://controlplane:6443

- name: development
  cluster:
    certificate-authority: /etc/kubernetes/pki/ca.crt
    server: https://controlplane:6443

- name: kubernetes-on-aws
  cluster:
    certificate-authority: /etc/kubernetes/pki/ca.crt
    server: https://controlplane:6443

- name: test-cluster-1
  cluster:
    certificate-authority: /etc/kubernetes/pki/ca.crt
    server: https://controlplane:6443

contexts:
- name: test-user@development
  context:
    cluster: development
    user: test-user

- name: aws-user@kubernetes-on-aws
  context:
    cluster: kubernetes-on-aws
    user: aws-user

- name: test-user@production
  context:
    cluster: production
    user: test-user

- name: research
  context:
    cluster: test-cluster-1
    user: dev-user

users:
- name: test-user
  user:
    client-certificate: /etc/kubernetes/pki/users/test-user/test-user.crt
    client-key: /etc/kubernetes/pki/users/test-user/test-user.key
- name: dev-user
  user:
    client-certificate: /etc/kubernetes/pki/users/dev-user/developer-user.crt
    client-key: /etc/kubernetes/pki/users/dev-user/dev-user.key
- name: aws-user
  user:
    client-certificate: /etc/kubernetes/pki/users/aws-user/aws-user.crt
    client-key: /etc/kubernetes/pki/users/aws-user/aws-user.key

current-context: test-user@development
preferences: {}
```

```yaml
kubectl config --kubeconfig=/root/my-kube-config use-context research
kubectl config --kubeconfig=/root/my-kube-config current-context
```

If you need to set another kubeconfig file in the bash environment.. you need to expose KUBECONFIG in ~/.bashrc

```yaml
vim ~/.bashrc
export KUBECONFIG=/root/my-kube-config 
source ~/.bashrc
kubectl config get-contexts
```

## role and rolebindings

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list", "create", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: dev-user-binding
subjects:
- kind: User
  name: dev-user
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer
  apiGroup: rbac.authorization.k8s.io
```

```yaml
kubectl get roles
kubectl get rolebindings
kubectl describe role developer
kubectl describe rolebinding devuser-developer-binding

kubectl auth can-i create deployments
kubectl auth can-i create pods --as dev-user
kubectl auth can-i create pods --as dev-user -n namespace
```

Limited permission on the resources

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "create", "update"]
  resourceNames: ["blue", "orange"] # restrict access "blue" and "orange" pods
```

### RBAC practice examples

#### Example 1 : Read-only access to Pods in a namespace

```yaml
kubectl create namespace demo

# pod-reader-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: demo
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]


kubectl apply -f pod-reader-role.yaml

kubectl create sa demo-user -n demo

# bind-sa.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods-binding
  namespace: demo
subjects:
  - kind: ServiceAccount
    name: demo-user
    namespace: demo
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io

kubectl apply -f bind-sa.yaml

kubectl auth can-i list pods --as=system:serviceaccount:demo:demo-user -n demo

kubectl auth can-i create pods --as=system:serviceaccount:demo:demo-user -n demo

```

#### Example 2 : Give access to ALL namespaces (ClusterRole)

```yaml
# cluster-role-pod-reader.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: pod-reader-all
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list"]


kubectl apply -f cluster-role-pod-reader.yaml

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: read-pods-everywhere
subjects:
  - kind: ServiceAccount
    name: demo-user
    namespace: demo
roleRef:
  kind: ClusterRole
  name: pod-reader-all
  apiGroup: rbac.authorization.k8s.io


kubectl apply -f cluster-role-binding.yaml

kubectl auth can-i get pods --as=system:serviceaccount:demo:demo-user -A


```

#### Example 3: Deny access (default behavior)

```yaml

kubectl auth can-i delete nodes
kubectl auth can-i create deployments


```

#### Example 4: Admin role for a namespace

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: namespace-admin
  namespace: demo
rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["*"]

kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: demo-admin-binding
  namespace: demo
subjects:
  - kind: User
    name: sunil
roleRef:
  kind: Role
  name: namespace-admin
  apiGroup: rbac.authorization.k8s.io


kubectl auth can-i create deployments --as sunil -n demo

kubectl auth can-i delete pods --as bob -n demo 

```

#### Example 5: Create a limited ServiceAccount for a Deployment (BEST PRACTICE)

```yaml

kubectl create sa app-sa -n demo

kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: cm-reader
  namespace: demo
rules:
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get"]


kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: cm-reader-binding
  namespace: demo
subjects:
  - kind: ServiceAccount
    name: app-sa
roleRef:
  kind: Role
  name: cm-reader
  apiGroup: rbac.authorization.k8s.io


apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  namespace: demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      serviceAccountName: app-sa
      containers:
        - name: app
          image: nginx
```

#### Example 6 Create new user to get access to the nodes

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: node-admin
rules:
  - apiGroups: [" "]
    resources: ["nodes"]
    verbs: ["get", "watch", "list", "create", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: all-node-status
subjects:
  - kind: User
    name: michelle
roleRef:
  kind: ClusterRole
  name: node-admin
  apiGroup: rbac.authorization.k8s.io
```

#### Example 6 Create new user to get access to the storage

```yaml
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: storage-admin
rules:
- apiGroups: [""]
  resources: ["persistentvolumes"]
  verbs: ["get", "watch", "list", "create", "delete"]
- apiGroups: ["storage.k8s.io"]
  resources: ["storageclasses"]
  verbs: ["get", "watch", "list", "create", "delete"]

---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: michelle-storage-admin
subjects:
- kind: User
  name: michelle
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: storage-admin
  apiGroup: rbac.authorization.k8s.io
```

### Real-World RBAC Scenarios Used by Companies

🟣 Scenario 1: Dev team should deploy only in dev namespace
❌ Cannot touch Production
❌ Cannot see Secrets
❌ Cannot delete resources
✔ Can create/update deployments

Solution:

Create a Role in dev namespace:

verbs: [create, update, list, get]

resources: deployments, pods, services

Bind to Dev team group dev-team-group

No permissions in prod namespace

🟣 Scenario 2: SRE team has full cluster-wide access
✔ Manage nodes
✔ Restart kube-system pods
✔ Apply cluster CRDs
✔ Debug any namespace

Solution:

ClusterRole = cluster-admin

ClusterRoleBinding → SRE group (sre-admins)

This is identical to real enterprise SRE teams.

🟣 Scenario 3: CI/CD Pipeline needs limited access

Jenkins or GitHub Actions needs:

Create deployments

Patch existing deployments

Cannot delete

Cannot list secrets

Can read configmaps

Cannot access nodes

Solution:

Create a ServiceAccount ci-bot and bind:

verbs: [create, update, patch]
resources: [deployments, pods]


This prevents pipeline mistakes from harming the cluster.

🟣 Scenario 5: Application Pods need only ConfigMap read access

A microservice should:

Read its own ConfigMap

NOT read other ConfigMaps

NOT read Secrets

NOT list pods

Solution:

Role:

resources: ["configmaps"]
verbs: ["get"]


Bind to its service account app-sa.

🟣 Scenario 6: Auditors need read-only access to everything

Read pods, logs, nodes, events

Read cluster scope resources

Cannot modify anything

Cannot exec into pods

This is used by Governance/Risk/Compliance (GRC) teams.

Solution:
ClusterRole:

verbs: [get, list, watch]
resources: ["*"]


Binding:
auditor-group

🟣 Scenario 7: Break-glass access for emergencies

For Sev1 incident:

Temporary full access

Scoped to certain on-call users

Automatically expires

Solution:

Create time-bound ClusterRoleBinding

Use automation to revoke it after X minutes

🟣 Scenario 8: Multi-Tenant Cluster Access

Teams A, B, C working in same cluster.

Each gets its own namespace

Each gets admin in only their namespace

No cross-namespace access

Companies like IBM, Red Hat, AWS use this pattern.

🟣 Scenario 9: Developer wants to use kubectl logs but NOT exec

This is common for security.

Role:

resources:
  - pods
  - pods/log       # allow logs
verbs:
  - get
  - list


Deny exec:

resources: ["pods/exec"]
verbs: []


Since exec is not permitted → denied automatically.

🟣 Scenario 10: ArgoCD / Flux GitOps RBAC

GitOps controllers need:

Read namespaces

Create deployments

Manage CRDs

Watch events

Patch resources

But must NOT:

Delete PVCs

Delete Namespaces

Delete CRDs

Fine-grained RBAC ensures safe reconciliation loops.

🟣 Scenario 11: Database Operator (Postgres/MySQL operator)

Needs:

Create StatefulSets

Manage PVCs

Watch CRDs

Update secrets (DB credentials)

Must not modify unrelated workloads

Operators require very specific ClusterRoles.

🟣 Scenario 12: Ingress Controller RBAC

Nginx/Istio needs:

Read Ingress objects

Watch Services and Endpoints

Update Status fields

Read ConfigMaps for config

But cannot modify workloads.

🟣 Scenario 13: Logs/ELK/EFK Stack

Fluentd/Fluentbit needs:

Read Pod metadata

Access /var/log

Watch namespaces & containers

ClusterRole:

verbs: [get, list, watch]
resources: [pods, namespaces]

🟣 Scenario 14: Vault Injector needs access to Secrets only to read

Secret Injector (Vault Agent) needs:

Read only a specific secret

Write into container volume

Access only its namespace

Role:

resources: ["secrets"]
resourceNames: ["app-secret"]
verbs: ["get"]


This is used in secure enterprises.