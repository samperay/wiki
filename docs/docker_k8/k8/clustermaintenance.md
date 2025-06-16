# Cluster Maintenance

## OS Upgrades

if there are any deployments that are on the nodes, we would like to move to another node hence we `cordon` the node and `drain` it, so that the existing applications(deployments) would be re-created into another node.

```
kubectl drain node01
kubectl describe node node01 | grep -i taint
kubectl cordon node01
kubectl describe node node01 | grep -i taint
kubectl drain --ignore-daemonsets --force
```

# Cluster Upgrade process

first, check how many nodes does exists and nodestatus.

```
kubectl describe node node01 | grep -i taint
kubectl describe node master | grep -i taint
```

Check for the latest version of the cluster using `kubeadm` tool

```
kubeadm upgrade plan
```

Once you know it has to be upgraded, upgrade one node followed by another.

```
kubectl cordon master
kubectl drain master --ignore-daemonsets
```

On master,

```
apt update
apt install kubeadm=1.19.0-00
kubeadm upgrade apply v1.19.0
apt install kubelet=1.19.0-00
system restart kubelet
```

```
kubectl uncordon master
kubectl describe node master | grep -i taint
```

then, worker node

```
apt update
apt install kubeadm=1.19.0-00
apt install kubelet=1.19.0-00
system restart kubelet
```

## etcd backup

```
ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt
--cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key
snapshot save /opt/snapshot-pre-boot.db
```

## etcd restore

```
ETCDCTL_API=3 etcdctl --data-dir /var/lib/etcd-from-backup
snapshot restore /opt/snapshot-pre-boot.db
```

Modify, /etc/kubernetes/manifests/etcd.yaml
and in the hostPath mention: `/var/lib/etcd-from-backup` wait for few minutes, then check the applications. 
