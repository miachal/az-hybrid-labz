#### Task 1. Creating a pod with a liveness probe

```
> kubectl create -f pod_liveness.yaml 
pod/my-liveness-pod created

> kubectl get pods
NAME              READY   STATUS    RESTARTS   AGE
my-liveness-pod   1/1     Running   0          4s

> kubectl logs my-liveness-pod
Welcome to Kubernetes!

> kubectl describe pod my-liveness-pod
...
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  35s   default-scheduler  Successfully assigned default/my-liveness-pod to aks-agentpool-10697719-vmss000000
  Normal  Pulling    34s   kubelet            Pulling image "busybox"
  Normal  Pulled     34s   kubelet            Successfully pulled image "busybox" in 804.563715ms
  Normal  Created    34s   kubelet            Created container myapp-container
  Normal  Started    33s   kubelet            Started container myapp-container

> kubectl delete pod my-liveness-pod
pod "my-liveness-pod" deleted
```

#### Task 2. Creating pod with readiness probe

```
> kubectl create -f pod_readiness.yaml 
pod/my-readiness-pod created

> kubectl get pods 
NAME               READY   STATUS    RESTARTS   AGE
my-readiness-pod   0/1     Running   0          7s

> kubectl get pods 
NAME               READY   STATUS    RESTARTS   AGE
my-readiness-pod   1/1     Running   0          22s

> kubectl delete pod my-readiness-pod
pod "my-readiness-pod" deleted

> kubectl create -f pod_readiness.yaml && kubectl get pods -w
pod/my-readiness-pod created
NAME               READY   STATUS              RESTARTS   AGE
my-readiness-pod   0/1     ContainerCreating   0          0s
my-readiness-pod   0/1     Running             0          2s
my-readiness-pod   1/1     Running             0          35s

> kubectl delete pod my-readiness-pod
pod "my-readiness-pod" deleted
```