# Troubleshooting

Basic commands required to troubleshoot application

```
kubeclt get all 
kubectl get all -A
kubectl get -n <namespace> deployments -o yaml
kubectl get pods -A
kubectl get pods -n <namespace>
kubectl describe pod <podname> -n <namespace>
kubectl describe node # check for events
kubectl logs <podname> -n namespace
kubectl get events -n <namespace>
kubectl logs -n <namespace> --all-containers
kubectl logs <podname> -c <container>
kubectl logs -l app=webtier
kubectl logs podname --timestamps 
kubectl logs podname since=5s
kubectl logs -n <namespace> <pod> --since=1h # logs since 1hr
kubectl logs <podname> -n namespace -f
kubectl exec -n <namespace> <podname> -- ls 
kubectl exec -n <namespace> <podname> -c <container> --ls
kubectl exec -n <namespace> <podname> -c <container> -it bash
kubectl port-forward -n <namespace> svc/app.service laptop:listeningport
kubectl explain <resource>.spec # documentation
kubectl top node # memory/CPU
kubectl auth can-i list pods -n namespace
kubectl auth whoami
kubectl diff

kubectl rollout restart deployment -n <namespace> <deployment>
kubectl get events -n <namespace>

kubectl debug - why ?
- minimize pod disruptions
- distroless images
- crashed container
```

ephemeral containers useful

- When using distroless images
- Images doesn’t contain debugging utilities
- Debugging container in a crashloop

Create debug pod for troubleshooting

```
kubectl debug -it ephemeral --image=busybox:1.28 --target=ephemeral
```

```
kubectl debug -it ephemeral --image=busybox:1.28 --target=ephemeral
Targeting container "ephemeral". If you don't see processes from this container it may be because the container runtime doesn't support this feature.
--profile=legacy is deprecated and will be removed in the future. It is recommended to explicitly specify a profile, for example "--profile=general".
Defaulting debug container name to debugger-gvbx8.
If you don't see a command prompt, try pressing enter.
/ # ps aux
PID   USER     TIME  COMMAND
    1 root      0:00 /pause
   56 root      0:00 sh
  112 root      0:00 ps aux
/ # 
```

upon exiting the shell, the container gets terminated. 

## Application Failures

- Application/Service status of the webserver
- endpoint of the service and compare it with the selectors
- status and logs of the pod
- logs of the previous pod

```
curl http://web-service-ip:node-port
kubectl describe service web-service
kubectl get pod
kubectl describe pod web
kubectl logs web
kubectl logs web -f --previous
```

## Control Plane Failure

- Nodes in the cluster, are they Ready or NotReady, If they are NotReady then check the LastHeartbeatTime of the node to find out the time when node might have crashed
- Possible CPU and MEMORY using top and df -h
- Status and the logs of the kubelet for the possible issues.
- Check the kubelet Certificates, they are not expired, and in the right group and issued by the right CA

```
kubectl get nodes
kubectl describe node worker-1
top
df -h
serivce kubelet status
sudo journalctl –u kubelet
openssl x509 -in /var/lib/kubelet/worker-1.crt -text
```
## Worker nodes failure

- Status of the Nodes in the cluster, are they Ready or NotReady
- If they are NotReady then check the LastHeartbeatTime of the node
- Check the possible CPU and MEMORY using top and df -h
- Check the status and the logs of the kubelet for the possible issues.
- Check the kubelet Certificates, they are not expired, and in the right group and issued by the right CA.

```
kubectl get nodes
kubectl describe node worker-1
serivce kubelet status
sudo journalctl –u kubelet
openssl x509 -in /var/lib/kubelet/worker-1.crt -text
```

## Network Failures
