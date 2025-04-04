## Image pull error 

- incorrect image
- incorect image tags
- incorrect secrets

## Crashing pods

it restarts bcoz of the pod definition file has `restartPolicy: Always`. It can also be set as `never` or `on failure`

- not providing ENV variable it can be `secrets` or `configmaps`
- permission issues
- Unable to find the file/volume.
- OOMkilled
- liveness or rediness probes endpoint

## pending pods

- insufficient cpu
- taints on the node
- node selector or missing labels 
- missing toleration on nodes

## missing pods

- resource quota on your namespace
- necessary resource accounts or dependencies on your namespace

Always, check the events i.e `kubectl get events -n <namespace>`

## Schrödinger's Deployment

Always **labels** in the deployment when created would get the same match for the pods, which will forward traffic to the nodes. 
**Note**: you must also have the **same label configured for the service** as well to respond the traffic back. 

```yaml
kubectl get pods -l app=web
kubectl get svc -l app=web
kubectl get endpoints
```
