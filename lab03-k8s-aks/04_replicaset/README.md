#### Task 1. Creating a ReplicaSet

```
> kubectl create -f rs.yaml 
replicaset.apps/frontend created

> kubectl get pods
NAME             READY   STATUS    RESTARTS   AGE
frontend-7qqmz   1/1     Running   0          9s
frontend-dnddg   1/1     Running   0          9s
frontend-g7wzc   1/1     Running   0          9s
```

#### Task 2. Inspecting ReplicaSet and its behaviour

```
> kubectl get rs
NAME       DESIRED   CURRENT   READY   AGE
frontend   3         3         3       78s

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
  Normal  SuccessfulCreate  84s   replicaset-controller  Created pod: frontend-g7wzc
  Normal  SuccessfulCreate  84s   replicaset-controller  Created pod: frontend-dnddg
  Normal  SuccessfulCreate  84s   replicaset-controller  Created pod: frontend-7qqmz

> kubectl get pods -l app=frontend
NAME             READY   STATUS    RESTARTS   AGE
frontend-7qqmz   1/1     Running   0          106s
frontend-dnddg   1/1     Running   0          106s
frontend-g7wzc   1/1     Running   0          106s

> kubectl delete pod frontend-dnddg && kubectl get pods -w
pod "frontend-dnddg" deleted
NAME             READY   STATUS    RESTARTS   AGE
frontend-7qqmz   1/1     Running   0          2m12s
frontend-g7wzc   1/1     Running   0          2m12s
frontend-wmrdh   1/1     Running   0          2s
```

#### Task 3. Scaling ReplicaSet

```
> kubectl scale rs frontend --replicas=5 && kubectl get pods -w -l app=frontend
replicaset.apps/frontend scaled
NAME             READY   STATUS              RESTARTS   AGE
frontend-7qqmz   1/1     Running             0          3m56s
frontend-fpxhz   0/1     ContainerCreating   0          0s
frontend-g7wzc   1/1     Running             0          3m56s
frontend-rw9rs   0/1     ContainerCreating   0          0s
frontend-wmrdh   1/1     Running             0          106s
frontend-rw9rs   1/1     Running             0          1s
frontend-fpxhz   1/1     Running             0          1s
```

#### Task 4. Detach ReplicaSet from pods

```
> kubectl delete rs frontend --cascade=false
warning: --cascade=false is deprecated (boolean value) and can be replaced with --cascade=orphan.
replicaset.apps "frontend" deleted

> kubectl get pods -l app=frontend
NAME             READY   STATUS    RESTARTS   AGE
frontend-7qqmz   1/1     Running   0          5m9s
frontend-fpxhz   1/1     Running   0          73s
frontend-g7wzc   1/1     Running   0          5m9s
frontend-rw9rs   1/1     Running   0          73s
frontend-wmrdh   1/1     Running   0          2m59s

> kubectl delete pod frontend-g7wzc
pod "frontend-g7wzc" deleted

> kubectl get pods -l app=frontend
NAME             READY   STATUS    RESTARTS   AGE
frontend-7qqmz   1/1     Running   0          5m30s
frontend-fpxhz   1/1     Running   0          94s
frontend-rw9rs   1/1     Running   0          94s
frontend-wmrdh   1/1     Running   0          3m20s

> kubectl create -f rs.yaml 
replicaset.apps/frontend created

> kubectl get pods -l app=frontend
NAME             READY   STATUS    RESTARTS   AGE
frontend-7qqmz   1/1     Running   0          6m4s
frontend-rw9rs   1/1     Running   0          2m8s
frontend-wmrdh   1/1     Running   0          3m54s

> kubectl delete rs frontend
replicaset.apps "frontend" deleted

> kubectl get pods
No resources found in default namespace.
```