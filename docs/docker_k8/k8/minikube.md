```bash
minikube start --driver=vfkit --network=nat
kubectl create deployment my-nginx --image=nginx
kubectl get pods
kubectl expose deployment my-nginx --port=80 --type=NodePort
minikube service my-nginx
```

```bash
➜  ~ kubectl create deployment my-nginx --image=nginx
deployment.apps/my-nginx created

➜  ~ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
my-nginx-54fc6798c5-sz52d   1/1     Running   0          25s
➜  ~ kubectl expose deployment my-nginx --port=80 --type=NodePort
service/my-nginx exposed
➜  ~
➜  ~ minikube service my-nginx
┌───────────┬──────────┬─────────────┬────────────────────────────┐
│ NAMESPACE │   NAME   │ TARGET PORT │            URL             │
├───────────┼──────────┼─────────────┼────────────────────────────┤
│ default   │ my-nginx │ 80          │ http://192.168.106.4:30869 │
└───────────┴──────────┴─────────────┴────────────────────────────┘
🎉  Opening service default/my-nginx in default browser...
```