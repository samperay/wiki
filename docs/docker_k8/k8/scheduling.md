# Scheduling

##  NodeName

You can make the pod run in a specific node using `nodeName`. 

[pod scheduler](./cmdref.md#pod-scheduler)

## Labels & Selectors
Labels and Selectors are standard methods to group things together. Labels are properties attach to each item. 
Selectors help you to filter these items

[selctors](./cmdref.md#labels-and-selectors)

# Taints and Tolerations

Taints are applied on nodes.

Tolerations are applied on pods.

✔ Taints repel pods # Only people with a matching pass can enter
✔ Tolerations allow pods to schedule on tainted nodes .

Pods must have the correct toleration to “pass through” the taint.

there are 3 policies of taints:

The taint effect defines what would happen to the pods if they **do not tolerate the taint.**

- NoSchedule - Pod will NOT schedule unless it tolerates this taint
- PreferNoSchedule - Avoid scheduling but not strictly enforced
- NoExecute - New pods cannot schedule, existing pods are evicted

The default policy of the any node is no taints so that any pod can be placed in any of the nodes.

Default, master nodes have a **NoSchedule** so that there won't be any pods running on the master nodes.
We would for the testing purpose *untaint* the node and then *revert* back

[taints and tolerations](./cmdref.md#taint-and-tolerations)

# NodeSelector

We add new property called Node Selector to the spec section and specify the label. The scheduler uses these labels to match and identify the right node to place the pods onto the nodes.

Label the nodes to ensure your pod is getting scheduled on a desired right nodes by kube-scheduler, however you can't really guarantee that the pods does only gets scheduled on the label being added. sometimes it might also get scheduled to other nodes as well. So, to fix this we would add nodeAffinity on the pods sections.

If there are more complex operations(==, !=, etc) are involved then we might not be able to achieve using nodeSelector, so we need to use *nodeAffinity* and *anti-affinity*

default labels of the node
```
get nodes node01 --show-labels
kubectl label nodes kubenode01 size=small
```

# Node Affinity
The primary feature of Node Affinity is to ensure that the pods are hosted on particular nodes.

## Node Affinity Types

### Available
- requiredDuringSchedulingIgnoredDuringExecution
- preferredDuringSchedulingIgnoredDuringExecution

### Planned
- requiredDuringSchedulingRequriedDuringExecution
- preferredDuringSchedulingRequiredDuringExecution

# Resource & Limits
Each node has a set of CPU, Memory and Disk resources available.
By default, K8s assume that a pod or container within a pod requires 0.5 CPU and 256Mi of memory. This is known as the Resource Request for a container.

If your application within the pod requires more than the default resources, you need to set them in the pod definition file.

```
resources:
     requests:
      memory: "1Gi"
      cpu: "1"
```


## Limits
By default, k8s sets resource limits to 1 CPU and 512Mi of memory
You can set the resource limits in the pod definition file.
```
limits:
  memory: "2Gi"
  cpu: "2"
```

Check the pod [limitrange.yaml](https://github.com/samperay/CKA/blob/master/studyguide/scheduling/examples/limitrange.yaml)

Note: Remember Requests and Limits for resources are set per container in the pod.

# DaemonSet

DaemonSets are like replicaSet, as it helps in to deploy multiple instances of pod. But it runs one copy of your pod on each node in your cluster.

Daemonset use cases:
- Monitoring solution
- logviewer
- Helper pods for applications
- Networking pods (weave net)

# Static pods
When you need to create pods without any interference from the kubeapi server or kubernetes management control plane, you can write your yaml files and place in the kubelet directory and create pods. these kind of pods which have no interference from the any of the kubernetes components are called as *static pod*

What if we run the static pods and if these nodes are part of kubernetes manage control plane, would it be known to kubeapi server? Yes kubeapi server would be known that there is pod running in the node as kubelet provides a mirror object in the kubeapi as read-only object.


## First Method

You can configure the kubelet to read the pod definition files from a directory on the server designated to store information about pods.The designated directory can be any directory on the host and the location of that directory is passed in to the kubelet as an option while running the service. *--pod-manifest-path*

```
systemctl status kubelet.service
cat /lib/systemd/system/kubelet.service
ExecStart=/usr/local/bin/kubelet \\
.
.
--pod-manifest-path=/etc/kubernetes/manifests
.
```

Create a static pod
```
kubectl run --restart=Never --image=busybox static-busybox --dry-run=client -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml

kubectl get pods
```

## Second Method
Incase if you have created kubeadmin way of configuring the cluster, your manifests will be in below location.
```
systemctl status kubelet.service
cat /var/lib/kubelet/config.yaml

look for "staticPodPath: /etc/kubernetes/manifests"
```

## Multiple schedulers
https://kubernetes.io/docs/tasks/extend-kubernetes/configure-multiple-schedulers/

[my-scheduler pod](https://github.com/samperay/CKA/blob/master/studyguide/scheduling/examples/my-scheduler.yaml)

we could ask nginx to create a pod using my-scheduler

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx-my-scheduler
  labels:
    name: nginx-pod
spec:
  schedulerName: my-scheduler <== custom scheduler.
  containers:
  - name: nginx
    image: nginx
```
