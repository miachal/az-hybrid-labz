#### Task 0. When to use a ReplicaSet
A ReplicaSet ensures that a specified number of pod replicas are running at any given time. However, a Deployment is a higher-level concept that manages ReplicaSets and provides declarative updates to Pods along with a lot of other useful features. Therefore, we recommend using Deployments instead of directly using ReplicaSets, unless you require custom update orchestration or don't require updates at all.

This actually means that you may never need to manipulate ReplicaSet objects: use a Deployment instead, and define your application in the spec section.


#### Task 1. Creating a ReplicaSet

```
> kubectl apply -f rs.yaml 
error: resource mapping not found for name: "frontend" namespace: "" from "rs.yaml": no matches for kind "ReplicaSet" in version "extensions/v1beta1"
ensure CRDs are installed first
```

```
// rs.yaml
apiVersion: apps/v1
...
spec:
  selector: ...
...
```

```
> kubectl apply -f rs.yaml 
replicaset.apps/frontend created

> kubectl get pods
NAME             READY   STATUS    RESTARTS   AGE
frontend-chzwt   1/1     Running   0          55s
frontend-w9b8t   1/1     Running   0          55s
frontend-z8rw2   1/1     Running   0          55s

> kubectl get rs
NAME       DESIRED   CURRENT   READY   AGE
frontend   3         3         3       2m
```

#### Task 2. Inspecting ReplicaSet and its behaviour

```
> kubectl describe rs frontend
Name:         frontend
Namespace:    default
Selector:     app=frontend
Labels:       <none>
Annotations:  <none>
Replicas:     3 current / 3 desired
Pods Status:  3 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app=frontend
  Containers:
   frontend:
    Image:        nginx:1.17.3
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:
  Type    Reason            Age   From                   Message
  ----    ------            ----  ----                   -------
  Normal  SuccessfulCreate  3m1s  replicaset-controller  Created pod: frontend-w9b8t
  Normal  SuccessfulCreate  3m1s  replicaset-controller  Created pod: frontend-z8rw2
  Normal  SuccessfulCreate  3m1s  replicaset-controller  Created pod: frontend-chzwt
```

```
> kubectl get pods -l app=frontend
NAME             READY   STATUS    RESTARTS   AGE
frontend-chzwt   1/1     Running   0          3m58s
frontend-w9b8t   1/1     Running   0          3m58s
frontend-z8rw2   1/1     Running   0          3m58s

> kubectl delete pod frontend-chzwt
pod "frontend-chzwt" deleted

> kubectl get pods -l app=frontend
NAME             READY   STATUS    RESTARTS   AGE
frontend-65td6   1/1     Running   0          6s
frontend-w9b8t   1/1     Running   0          4m17s
frontend-z8rw2   1/1     Running   0          4m17s
```

#### Task 3. Scaling ReplicaSet

```
> kubectl scale rs frontend --replicas=5
replicaset.apps/frontend scaled

> kubectl get pods -l app=frontend
NAME             READY   STATUS    RESTARTS   AGE
frontend-65td6   1/1     Running   0          95s
frontend-qhbnl   1/1     Running   0          7s
frontend-tqw22   1/1     Running   0          7s
frontend-w9b8t   1/1     Running   0          5m46s
frontend-z8rw2   1/1     Running   0          5m46s
```

#### Task 4. Detach ReplicaSet from pods

```
> kubectl delete rs frontend --cascade=false
warning: --cascade=false is deprecated (boolean value) and can be replaced with --cascade=orphan.
replicaset.apps "frontend" deleted
```

```
    --cascade='background':
        Must be "background", "orphan", or "foreground". Selects the deletion cascading strategy for the dependents
        (e.g. Pods created by a ReplicationController). Defaults to background
```

```
> kubectl get pods -l app=frontend
NAME             READY   STATUS    RESTARTS   AGE
frontend-65td6   1/1     Running   0          4m51s
frontend-qhbnl   1/1     Running   0          3m23s
frontend-tqw22   1/1     Running   0          3m23s
frontend-w9b8t   1/1     Running   0          9m2s
frontend-z8rw2   1/1     Running   0          9m2s

> kubectl delete pod frontend-tqw22
pod "frontend-tqw22" deleted

> kubectl get pods -l app=frontend
NAME             READY   STATUS    RESTARTS   AGE
frontend-65td6   1/1     Running   0          5m18s
frontend-qhbnl   1/1     Running   0          3m50s
frontend-w9b8t   1/1     Running   0          9m29s
frontend-z8rw2   1/1     Running   0          9m29s
```

```
> kubectl apply -f rs.yaml 
replicaset.apps/frontend created

> kubectl get pods -l app=frontend
NAME             READY   STATUS    RESTARTS   AGE
frontend-65td6   1/1     Running   0          7m39s
frontend-w9b8t   1/1     Running   0          11m
frontend-z8rw2   1/1     Running   0          11m
```

```
> kubectl delete rs frontend
replicaset.apps "frontend" deleted

> kubectl get pods -l app=frontend
No resources found in default namespace.
```
