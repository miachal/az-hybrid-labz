#### Task 1. Creating a deployment

```
> kubectl apply -f deployment.yaml
deployment.apps/deployment created

> kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
deployment   3/3     3            3           7s

> kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
deployment-54f7cd5bc7-4qmlg   1/1     Running   0          30s
deployment-54f7cd5bc7-f6grr   1/1     Running   0          30s
deployment-54f7cd5bc7-tpxs5   1/1     Running   0          30s
```

#### Task 2. Exploring deployment

```
> kubectl get deployments deployment -o jsonpath --template {.spec.selector.matchLabels}
{"app":"nginx"} 

> kubectl get rs -l app=nginx
NAME                    DESIRED   CURRENT   READY   AGE
deployment-54f7cd5bc7   3         3         3       2m20s

> kubectl scale deployments deployment --replicas 4
deployment.apps/deployment scaled

> kubectl get rs -l app=nginx
NAME                    DESIRED   CURRENT   READY   AGE
deployment-54f7cd5bc7   4         4         4       2m55s

>  kubectl scale rs deployment-54f7cd5bc7 --replicas=1
replicaset.apps/deployment-54f7cd5bc7 scaled

> kubectl get rs -l app=nginx
NAME                    DESIRED   CURRENT   READY   AGE
deployment-54f7cd5bc7   4         4         4       5m7s

```
```
> kubectl scale deployment deployment --replicas=1
deployment.apps/deployment scaled

> kubectl get rs -l app=nginx
NAME                    DESIRED   CURRENT   READY   AGE
deployment-54f7cd5bc7   1         1         1       6m38s

> kubectl get deployment -l app=nginx
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
deployment   1/1     1            1           6m48s
```

```
> kubectl delete -f deployment.yaml 
deployment.apps "deployment" deleted

> kubectl get pods
No resources found in default namespace.
```