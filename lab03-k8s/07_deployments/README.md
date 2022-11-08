#### Task 1. Creating a deployment

Deployment is managing ReplicaSet.

```
> kubectl apply -f deployment.yaml 
deployment.apps/deployment created

> kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
deployment   3/3     3            3           7s
```

#### Task 2. Exploring deployment

```
> kubectl get deployments deployment -o jsonpath --template {.spec.selector.matchLabels}
{"app":"nginx"} 

> kubectl get deployments deployment -o jsonpath --template {.spec.template.spec.containers}
[{"image":"nginx:1.17.3","imagePullPolicy":"IfNotPresent","name":"nginx","ports":[{"containerPort":80,"protocol":"TCP"}],"resources":{},"terminationMessagePath":"/dev/termination-log","terminationMessagePolicy":"File"}]> 

> kubectl get deployments deployment -o jsonpath --template {.spec.template.spec.containers[0].image}
nginx:1.17.3>
```

```
> kubectl get rs --selector='app=nginx'
NAME                    DESIRED   CURRENT   READY   AGE
deployment-54f7cd5bc7   3         3         3       5m16s
```

```
> kubectl scale deployments deployment --replicas=4
deployment.apps/deployment scaled

> kubectl get rs --selector='app=nginx'
NAME                    DESIRED   CURRENT   READY   AGE
deployment-54f7cd5bc7   4         4         4       6m3s

> kubectl get pods --selector='app=nginx'
NAME                          READY   STATUS    RESTARTS   AGE
deployment-54f7cd5bc7-4v48k   1/1     Running   0          62s
deployment-54f7cd5bc7-f7rc8   1/1     Running   0          7m3s
deployment-54f7cd5bc7-jgjlx   1/1     Running   0          7m3s
deployment-54f7cd5bc7-tbrh8   1/1     Running   0          7m3s
```

```
> kubectl scale rs deployment-54f7cd5bc7 --replicas=1
replicaset.apps/deployment-54f7cd5bc7 scaled

> kubectl get pods --selector='app=nginx'
NAME                          READY   STATUS    RESTARTS   AGE
deployment-54f7cd5bc7-4dr25   1/1     Running   0          17s
deployment-54f7cd5bc7-77mpt   1/1     Running   0          17s
deployment-54f7cd5bc7-f7rc8   1/1     Running   0          7m58s
deployment-54f7cd5bc7-sgwqp   1/1     Running   0          17s

> kubectl get rs
NAME                    DESIRED   CURRENT   READY   AGE
deployment-54f7cd5bc7   4         4         4       9m3s
```

Ale pody się ładnie zrestartowały chociaż... (;

```
> kubectl delete -f deployment.yaml
deployment.apps "deployment" deleted
```