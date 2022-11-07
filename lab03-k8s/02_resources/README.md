#### Task 1. Creating a pod.

[pod.yaml](pod.yaml)

```
> kubectl apply -f pod.yaml 
pod/my-resources-pod created

> kubectl get pods
NAME               READY   STATUS              RESTARTS   AGE
my-resources-pod   0/1     ContainerCreating   0          5s

> kubectl get pods
NAME               READY   STATUS    RESTARTS   AGE
my-resources-pod   1/1     Running   0          9s
```

```
> kubectl describe pods my-resources-pod
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
If the node where a Pod is running has enough of a resource available, it's possible (and allowed)  
for a container to use more resource than its request for that resource specifies.  
However, a container is not allowed to use more than its resource limit.
```

```
> kubectl apply -f stress.yaml 
pod/cpu-stress-pod created

> kubectl top pods cpu-stress-pod
error: Metrics API not available
```

:-(

```
> kubectl top -h
Display Resource (CPU/Memory) usage.
 The top command allows you to see the resource consumption for nodes or pods.
 This command requires Metrics Server to be correctly configured and working on the server.
```

[github.com/metrics-server](https://github.com/kubernetes-sigs/metrics-server)

```
> kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
serviceaccount/metrics-server created
clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader created
clusterrole.rbac.authorization.k8s.io/system:metrics-server created
rolebinding.rbac.authorization.k8s.io/metrics-server-auth-reader created
clusterrolebinding.rbac.authorization.k8s.io/metrics-server:system:auth-delegator created
clusterrolebinding.rbac.authorization.k8s.io/system:metrics-server created
service/metrics-server created
deployment.apps/metrics-server created
apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io created
```

```
> kubectl top pods cpu-stress-pod
Error from server (ServiceUnavailable): the server is currently unable to handle the request (get pods.metrics.k8s.io cpu-stress-pod)
```

:matko-bosko:

```
> kubectl get pods -n kube-system
NAME                                       READY   STATUS    RESTARTS       AGE
...
metrics-server-847dcc659d-kdx9t            0/1     Running   0              58m
```

```
> kubectl logs -n kube-system metrics-server-847dcc659d-kdx9t

I1107 22:19:20.094191       1 server.go:187] "Failed probe" probe="metric-storage-ready" err="no metrics to serve"
E1107 22:19:22.133081       1 scraper.go:140] "Failed to scrape node" err="Get \"https://192.168.129.207:10250/metrics/resource\": x509: cannot validate certificate for 192.168.129.207 because it doesn't contain any IP SANs" node="lke79380-122675-6369675b7714"
E1107 22:19:22.137355       1 scraper.go:140] "Failed to scrape node" err="Get \"https://192.168.161.207:10250/metrics/resource\": x509: cannot validate certificate for 192.168.161.207 because it doesn't contain any IP SANs" node="lke79380-122675-6369675bd241"
E1107 22:19:22.149247       1 scraper.go:140] "Failed to scrape node" err="Get \"https://192.168.171.112:10250/metrics/resource\": x509: cannot validate certificate for 192.168.171.112 because it doesn't contain any IP SANs" node="lke79380-122675-6369675b1613"
```

```
> kubectl edit pod -n kube-system metrics-server-847dcc659d-kdx9t
```

Niestety edycja argumentów w locie nie jest możliwa, więc ubijamy, ściągamy manifest, edytujemy go ręcznie i jeszcze raz stawiamy poda.

[metrics-server.yaml](metrics-server.yaml)
```
...
args:
  ...
  - kubelet-insecure-tls
  ...
```

```
> kubectl apply -f metrics-server.yaml

> kubectl get pods -n kube-system
NAME                                       READY   STATUS    RESTARTS       AGE
metrics-server-7cf8b65d65-wbnkf            1/1     Running   0              45s

> kubectl top nodes
NAME                           CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
lke79380-122675-6369675b1613   90m          9%     1271Mi          67%       
lke79380-122675-6369675b7714   131m         13%    1127Mi          59%       
lke79380-122675-6369675bd241   1000m        100%   1033Mi          54%    
```

Yay! Wracając do zadania

```
> kubectl top pod
NAME             CPU(cores)   MEMORY(bytes)   
cpu-stress-pod   901m         0Mi   

> kubectl delete pod cpu-stress-pod
pod "cpu-stress-pod" deleted
```

[stress_100.yaml](stress_100.yaml)

```
> kubectl apply -f stress_100.yaml 
The Pod "cpu-stress-pod" is invalid: spec.containers[0].resources.requests: Invalid value: "100": must be less than or equal to cpu limit

> kubectl get pods
No resources found in default namespace.
```

Yay.