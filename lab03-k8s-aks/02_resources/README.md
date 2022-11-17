#### Task 1. Creating a pod

```
> kubectl apply -f pod.yaml 
pod/my-resources-pod created

> kubectl get pods
NAME               READY   STATUS    RESTARTS   AGE
my-resources-pod   1/1     Running   0          4s
```

#### Task 2. Examing pod settings

```
> kubectl describe pod my-resources-pod
...
    Limits:
      cpu:     500m
      memory:  128Mi
    Requests:
      cpu:        250m
      memory:     64Mi
...
```

```
> kubectl delete pod my-resources-pod
pod "my-resources-pod" deleted
```

#### Task 3. Deploy pod that has high requirements

```
> kubectl apply -f stress.yaml 
pod/cpu-stress-pod created

> kubectl top pod cpu-stress-pod
Error from server (NotFound): podmetrics.metrics.k8s.io "default/cpu-stress-pod" not found

> kubectl top pod cpu-stress-pod
NAME             CPU(cores)   MEMORY(bytes)   
cpu-stress-pod   997m         1Mi  
```

```
> kubectl apply -f stress.yaml 

> kubectl get pods
NAME             READY   STATUS    RESTARTS   AGE
cpu-stress-pod   0/1     Pending   0          62s

> kubectl describe pod cpu-stress-pod
...
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  11s   default-scheduler  0/1 nodes are available: 1 Insufficient cpu.
...
```

```
> kubectl delete pod cpu-stress-pod
pod "cpu-stress-pod" deleted
```
