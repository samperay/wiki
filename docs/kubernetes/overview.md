# Overview


## Kubernetes architecture

- [Can you please explain about kubernetes architecture](https://github.com/samperay/CKA/blob/master/studyguide/intro/kubernetes_arch.md)


## CrashLoopBack

CrashLoopBackOff, the pod keeps crashing at one point right after it is deployed and run. It usually occurs because the pod is not starting correctly. Every Pod has a spec field which in turn has a RestartPolicy field. The possible values of this field are: Always, OnFailure, and Never. This value is applicable for all the containers in one particular pod. This policy refers to the restarts of the containers by the kubelet

Why does CrashLoopBackOff usually occur?

### Probe failure

The kubelet uses liveness, readiness, and startup probes to keep checks on the container.Ensure that all the specs (endpoint, port, SSL config, timeout, command) are correctly specified.

### OOM failure

Every pod has a specified memory space and when it tries to consume more memory than what has been allocated to it, the pod will keep crashing. 

To solve this error, you can increase the ram allocated to the pod. This would do the trick in usual cases. But, in case the pod is consuming excessive amounts of RAM, you will have to look into the application and look for the cause. If it is a Java application, check the heap configuration

### Application failure

the application within the container itself keeps crashing because of some error and that can cause the pod to crash on repeat

