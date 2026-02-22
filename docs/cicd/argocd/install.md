You can install in `non-HA` using `minikube` or `docker-desktop` or `rancher-desktop`

```
➜  ~ kubectl get nodes
NAME                   STATUS   ROLES                  AGE    VERSION
lima-rancher-desktop   Ready    control-plane,master   229d   v1.30.3+k3s1

➜  ~ kubectl create ns argocd
namespace/argocd created

➜  ~ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
customresourcedefinition.apiextensions.k8s.io/applications.argoproj.io created
customresourcedefinition.apiextensions.k8s.io/applicationsets.argoproj.io created
customresourcedefinition.apiextensions.k8s.io/appprojects.argoproj.io created
serviceaccount/argocd-application-controller created
serviceaccount/argocd-applicationset-controller created
serviceaccount/argocd-dex-server created
serviceaccount/argocd-notifications-controller created
serviceaccount/argocd-redis created
serviceaccount/argocd-repo-server created
serviceaccount/argocd-server created
role.rbac.authorization.k8s.io/argocd-application-controller created
role.rbac.authorization.k8s.io/argocd-applicationset-controller created
role.rbac.authorization.k8s.io/argocd-dex-server created
role.rbac.authorization.k8s.io/argocd-notifications-controller created
role.rbac.authorization.k8s.io/argocd-redis created
role.rbac.authorization.k8s.io/argocd-server created
clusterrole.rbac.authorization.k8s.io/argocd-application-controller created
clusterrole.rbac.authorization.k8s.io/argocd-applicationset-controller created
clusterrole.rbac.authorization.k8s.io/argocd-server created
rolebinding.rbac.authorization.k8s.io/argocd-application-controller created
rolebinding.rbac.authorization.k8s.io/argocd-applicationset-controller created
rolebinding.rbac.authorization.k8s.io/argocd-dex-server created
rolebinding.rbac.authorization.k8s.io/argocd-notifications-controller created
rolebinding.rbac.authorization.k8s.io/argocd-redis created
rolebinding.rbac.authorization.k8s.io/argocd-server created
clusterrolebinding.rbac.authorization.k8s.io/argocd-application-controller created
clusterrolebinding.rbac.authorization.k8s.io/argocd-applicationset-controller created
clusterrolebinding.rbac.authorization.k8s.io/argocd-server created
configmap/argocd-cm created
configmap/argocd-cmd-params-cm created
configmap/argocd-gpg-keys-cm created
configmap/argocd-notifications-cm created
configmap/argocd-rbac-cm created
configmap/argocd-ssh-known-hosts-cm created
configmap/argocd-tls-certs-cm created
secret/argocd-notifications-secret created
secret/argocd-secret created
service/argocd-applicationset-controller created
service/argocd-dex-server created
service/argocd-metrics created
service/argocd-notifications-controller-metrics created
service/argocd-redis created
service/argocd-repo-server created
service/argocd-server created
service/argocd-server-metrics created
deployment.apps/argocd-applicationset-controller created
deployment.apps/argocd-dex-server created
deployment.apps/argocd-notifications-controller created
deployment.apps/argocd-redis created
deployment.apps/argocd-repo-server created
deployment.apps/argocd-server created
statefulset.apps/argocd-application-controller created
networkpolicy.networking.k8s.io/argocd-application-controller-network-policy created
networkpolicy.networking.k8s.io/argocd-applicationset-controller-network-policy created
networkpolicy.networking.k8s.io/argocd-dex-server-network-policy created
networkpolicy.networking.k8s.io/argocd-notifications-controller-network-policy created
networkpolicy.networking.k8s.io/argocd-redis-network-policy created
networkpolicy.networking.k8s.io/argocd-repo-server-network-policy created
networkpolicy.networking.k8s.io/argocd-server-network-policy created
➜  ~

➜  ~ kubectl get all -n argocd
NAME                                                   READY   STATUS    RESTARTS   AGE
pod/argocd-application-controller-0                    1/1     Running   0          102s
pod/argocd-applicationset-controller-cc68b7b7b-6ck72   1/1     Running   0          103s
pod/argocd-dex-server-555b55c97d-qrrbq                 1/1     Running   0          103s
pod/argocd-notifications-controller-65655df9d5-drn4n   1/1     Running   0          103s
pod/argocd-redis-764b74c9b9-bkdrs                      1/1     Running   0          103s
pod/argocd-repo-server-7dcbcd967b-bxcjd                1/1     Running   0          103s
pod/argocd-server-5b9cc8b776-bjnqd                     1/1     Running   0          102s

NAME                                              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
service/argocd-applicationset-controller          ClusterIP   10.43.100.205   <none>        7000/TCP,8080/TCP            104s
service/argocd-dex-server                         ClusterIP   10.43.83.92     <none>        5556/TCP,5557/TCP,5558/TCP   104s
service/argocd-metrics                            ClusterIP   10.43.158.10    <none>        8082/TCP                     104s
service/argocd-notifications-controller-metrics   ClusterIP   10.43.106.252   <none>        9001/TCP                     103s
service/argocd-redis                              ClusterIP   10.43.67.82     <none>        6379/TCP                     103s
service/argocd-repo-server                        ClusterIP   10.43.17.137    <none>        8081/TCP,8084/TCP            103s
service/argocd-server                             ClusterIP   10.43.40.122    <none>        80/TCP,443/TCP               103s
service/argocd-server-metrics                     ClusterIP   10.43.40.210    <none>        8083/TCP                     103s

NAME                                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/argocd-applicationset-controller   1/1     1            1           103s
deployment.apps/argocd-dex-server                  1/1     1            1           103s
deployment.apps/argocd-notifications-controller    1/1     1            1           103s
deployment.apps/argocd-redis                       1/1     1            1           103s
deployment.apps/argocd-repo-server                 1/1     1            1           103s
deployment.apps/argocd-server                      1/1     1            1           103s

NAME                                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/argocd-applicationset-controller-cc68b7b7b   1         1         1       103s
replicaset.apps/argocd-dex-server-555b55c97d                 1         1         1       103s
replicaset.apps/argocd-notifications-controller-65655df9d5   1         1         1       103s
replicaset.apps/argocd-redis-764b74c9b9                      1         1         1       103s
replicaset.apps/argocd-repo-server-7dcbcd967b                1         1         1       103s
replicaset.apps/argocd-server-5b9cc8b776                     1         1         1       103s

NAME                                             READY   AGE
statefulset.apps/argocd-application-controller   1/1     102s
➜  ~
```

All the pods must be in running space 

```
➜  ~ kubectl get pods -n argocd
NAME                                               READY   STATUS    RESTARTS   AGE
argocd-application-controller-0                    1/1     Running   0          2m16s
argocd-applicationset-controller-cc68b7b7b-6ck72   1/1     Running   0          2m17s
argocd-dex-server-555b55c97d-qrrbq                 1/1     Running   0          2m17s
argocd-notifications-controller-65655df9d5-drn4n   1/1     Running   0          2m17s
argocd-redis-764b74c9b9-bkdrs                      1/1     Running   0          2m17s
argocd-repo-server-7dcbcd967b-bxcjd                1/1     Running   0          2m17s
argocd-server-5b9cc8b776-bjnqd                     1/1     Running   0          2m16s
➜  ~
```

You need to follow below steps for setup 

Get the initial password that is stored as secret in argocd namesapce
convert secret from base64 into plain text

```
➜  ~ kubectl get secret -n argocd argocd-initial-admin-secret -o yaml
apiVersion: v1
data:
  password: T2FDUFJ5d1pab0g1ODVuRQ==
kind: Secret
metadata:
  creationTimestamp: "2025-04-09T04:17:55Z"
  name: argocd-initial-admin-secret
  namespace: argocd
  resourceVersion: "775735"
  uid: aebfa38f-12fa-4a8d-adab-22ed8ed816ad
type: Opaque
➜  ~

➜  ~  echo "T2FDUFJ5d1pab0g1ODVuRQ=="|base64 -d
OaCPRywZZoH585nE%                                                                                                                                   ➜  ~
```

you could also use the below to get password

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```


Expose the argocd-server to connect to UI by port-forwarding

```
➜  ~ kubectl get svc -n argocd
NAME                                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
argocd-applicationset-controller          ClusterIP   10.43.100.205   <none>        7000/TCP,8080/TCP            8m38s
argocd-dex-server                         ClusterIP   10.43.83.92     <none>        5556/TCP,5557/TCP,5558/TCP   8m38s
argocd-metrics                            ClusterIP   10.43.158.10    <none>        8082/TCP                     8m38s
argocd-notifications-controller-metrics   ClusterIP   10.43.106.252   <none>        9001/TCP                     8m37s
argocd-redis                              ClusterIP   10.43.67.82     <none>        6379/TCP                     8m37s
argocd-repo-server                        ClusterIP   10.43.17.137    <none>        8081/TCP,8084/TCP            8m37s
argocd-server                             ClusterIP   10.43.40.122    <none>        80/TCP,443/TCP               8m37s
argocd-server-metrics                     ClusterIP   10.43.40.210    <none>        8083/TCP                     8m37s
➜  ~

➜  ~ kubectl port-forward svc/argocd-server -n argocd 8080:443
Forwarding from [::1]:8080 -> 8080

[ leave one terminal as such .....]
```

Now, you can connect your localhost with the url
http://localhost:8080

Username:admin
password:OaCPRywZZoH585nE

## ArgoCD Cli

what can be done using cli

- manage application 
- manage repos
- manage clusters
- admin tasks
- manage projects
- and more and more

### installations


https://argo-cd.readthedocs.io/en/stable/cli_installation/

```
➜  ~ VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
➜  ~ echo "${VERSION}"
v2.14.9
➜  ~ curl -sSL -o argocd-darwin-amd64 https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-darwin-amd64
➜  ~ sudo install -m 555 argocd-darwin-amd64 /usr/local/bin/argocd ;rm argocd-darwin-amd64
➜ 

➜  ~ argocd help | head
argocd controls a Argo CD server

Usage:
  argocd [flags]
  argocd [command]

Available Commands:
  account     Manage account settings
  admin       Contains a set of commands useful for Argo CD administrators and requires direct Kubernetes access
  app         Manage applications
➜  ~
```

Login to cli using admin

```
➜  ~ argocd login localhost:8080
WARNING: server certificate had error: tls: failed to verify certificate: x509: certificate signed by unknown authority. Proceed insecurely (y/n)? y
Username: admin
Password:
'admin:login' logged in successfully
Context 'localhost:8080' updated
➜  ~

➜  ~ argocd cluster list
SERVER                          NAME        VERSION  STATUS   MESSAGE                                                  PROJECT
https://kubernetes.default.svc  in-cluster           Unknown  Cluster has no applications and is not being monitored.
➜  ~

```

## Note

```
Make sure that ArgoCD server endpoint is accessible whether using port-forward or ingress or load balancer service.

example: kubectl port-forward svc/argocd-server -n argocd 8080:443

Remember to login into  ArgoCD using command argocd login.

you need admin user and password. remember that you can get the initial admin password from k8s secret "argocd-initial-admin-secret"


example : argocd login localhost:8080 --insecure

Then you can apply cli commands.
```