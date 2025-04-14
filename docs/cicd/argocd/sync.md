## Automated syncing

- by default, argocd polls git repo every 3 minutes to detect changes to the manifests. This will sync the desired manifests automaically to the live state in the cluster. 

Note: 

- automated sync will be performed only if the application is `OutOfSync`. it will not re-attemps if the automated sync has been failed against the same SHA Commmit.
- Rollback **cannot** be performed against an application with automated sync enabled. 

```
argocd app create application --repo https://... --revision 1.x.x.x --dest-namespace default --dest-server https://kubernetes.default.svc --sync-policy automated
```

```yaml
#automated-sync.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata: 
  name: auto-sync-app
  namespace: argocd
spec:
  destination:
    namespace: auto-sync-app
    server: "https://kubernetes.default.svc"
  project: default
  source: 
    path: guestbook-with-sub-directories
    repoURL: "https://github.com/mabusaa/argocd-example-apps.git"
    targetRevision: master
    directory:
      recurse: true
  syncPolicy:
    automated: {}
    syncOptions:
      - CreateNamespace=true
```

## Automated pruning

Default: No prune enabled. 

autosync when enabled, for safety purpose we have `auto prune` disabled so that when sync happends we will not delete any resources when detected for any changes. but it can be enabled. 
When using production please don't enable it. 


```yaml
# automated-prune.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata: 
  name: auto-pruning-demo
  namespace: argocd
spec: 
  destination:
    namespace: auto-pruning-demo
    server: "https://kubernetes.default.svc"
  project: default
  source: 
    path: guestbook-with-sub-directories
    repoURL: "https://github.com/mabusaa/argocd-example-apps.git"
    targetRevision: master
    directory:
      recurse: true
  syncPolicy:
    automated: 
      prune: true
    syncOptions:
      - CreateNamespace=true
```

```
argocd app create application --repo https://... --revision 1.x.x.x --dest-namespace default --dest-server https://kubernetes.default.svc --auto-prune
```

## Automated self-healing

by default, changes that are made to the live cluster will not trigger automated sync. argocd has a feature to enable self healing when the live cluster state deviates from the git state. 

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata: 
  name: auto-selfheal-demo
  namespace: argocd
spec: 
  destination:
    namespace: auto-selfheal-demo
    server: "https://kubernetes.default.svc"
  project: default
  source: 
    path: guestbook-with-sub-directories
    repoURL: "https://github.com/mabusaa/argocd-example-apps.git"
    targetRevision: master
    directory:
      recurse: true
  syncPolicy:
    automated:
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

```
argocd app create application --repo https://... --revision 1.x.x.x --dest-namespace default --dest-server https://kubernetes.default.svc --self-heal
```

## Sync options


