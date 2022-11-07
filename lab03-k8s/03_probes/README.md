#### Task 1. Creating a pod with a liveness probe.

[pod_liveness.yaml](pod_liveness.yaml)

```
> kubectl apply -f pod_liveness.yaml 
pod/my-liveness-pod created

> kubectl get pods
NAME              READY   STATUS    RESTARTS   AGE
my-liveness-pod   1/1     Running   0          4s

> kubectl delete pod my-liveness-pod
pod "my-liveness-pod" deleted
```

#### Task 2. Creating pod with readiness probe.

[pod_readiness.yaml](pod_readiness.yaml)

```
> kubectl apply -f pod_readiness.yaml 
pod/my-readiness-pod created

> kubectl get pods
NAME               READY   STATUS    RESTARTS   AGE
my-readiness-pod   0/1     Running   0          4s

> kubectl get pods
NAME               READY   STATUS    RESTARTS   AGE
my-readiness-pod   1/1     Running   0          3m3s

```

initialDelaySeconds: 30

```
> kubectl apply -f pod_readiness.yaml && kubectl get pods -w
pod/my-readiness-pod created
NAME               READY   STATUS              RESTARTS   AGE
my-readiness-pod   0/1     ContainerCreating   0          1s
my-readiness-pod   0/1     ContainerCreating   0          1s
my-readiness-pod   0/1     Running             0          4s
my-readiness-pod   1/1     Running             0          36s
```
