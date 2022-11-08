#### Task 1. Creating pods with labels

Labels provide identifying metadata for objects. These are fundamental qualities of the object that will be used for grouping, viewing, and operating.

```
> kubectl apply -f pod_labels.yaml 
pod/nginx-prod created
pod/nginx-test created
pod/nginx-dev created

> kubectl get pods --show-labels
NAME         READY   STATUS    RESTARTS   AGE   LABELS
nginx-dev    1/1     Running   0          15s   app=myapp,environment=dev,tier=frontend,version=1.2.0
nginx-prod   1/1     Running   0          15s   app=myapp,environment=production,tier=frontend,version=1.0.0
nginx-test   1/1     Running   0          15s   app=myapp,environment=test,tier=frontend,version=1.1.0
```

#### Task 2. Modifying labels

```
> kubectl get pods --show-labels
NAME         READY   STATUS    RESTARTS   AGE   LABELS
nginx-dev    1/1     Running   0          15s   app=myapp,environment=dev,tier=frontend,version=1.2.0
nginx-prod   1/1     Running   0          15s   app=myapp,environment=production,tier=frontend,version=1.0.0
nginx-test   1/1     Running   0          15s   app=myapp,environment=test,tier=frontend,version=1.1.0

> kubectl label pod nginx-prod new_label=ioio_bagiety_jado_na_proda
pod/nginx-prod labeled

> kubectl label pod nginx-test raz=1 dwa=2 trzy=3
pod/nginx-test labeled

> kubectl get pods --show-labels
NAME         READY   STATUS    RESTARTS   AGE     LABELS
nginx-dev    1/1     Running   0          3m26s   app=myapp,environment=dev,tier=frontend,version=1.2.0
nginx-prod   1/1     Running   0          3m26s   app=myapp,environment=production,new_label=ioio_bagiety_jado_na_proda,tier=frontend,version=1.0.0
nginx-test   1/1     Running   0          3m26s   app=myapp,dwa=2,environment=test,raz=1,tier=frontend,trzy=3,version=1.1.0

> kubectl label pod nginx-test raz- dwa- trzy-
pod/nginx-test unlabeled

> kubectl label pod nginx-prod new_label-
pod/nginx-prod unlabeled

> kubectl get pods --show-labels
NAME         READY   STATUS    RESTARTS   AGE     LABELS
nginx-dev    1/1     Running   0          3m52s   app=myapp,environment=dev,tier=frontend,version=1.2.0
nginx-prod   1/1     Running   0          3m52s   app=myapp,environment=production,tier=frontend,version=1.0.0
nginx-test   1/1     Running   0          3m52s   app=myapp,environment=test,tier=frontend,version=1.1.0
```

#### Task 3. Label selectors

```
> kubectl get pods --selector='environment=production'
NAME         READY   STATUS    RESTARTS   AGE
nginx-prod   1/1     Running   0          8m50s
```

```
> kubectl get pods --selector='environment in (production, test)' --show-labels
NAME         READY   STATUS    RESTARTS   AGE     LABELS
nginx-prod   1/1     Running   0          9m32s   app=myapp,environment=production,tier=frontend,version=1.0.0
nginx-test   1/1     Running   0          9m32s   app=myapp,environment=test,tier=frontend,version=1.1.0

> kubectl get pods --selector='version notin (1.1.0, 1.2.0)' --show-labels
NAME         READY   STATUS    RESTARTS   AGE   LABELS
nginx-prod   1/1     Running   0          10m   app=myapp,environment=production,tier=frontend,version=1.0.0
```

#### Task 4. Annotations

Annotations provide a place to store additional metadata for Kubernetes objects with the sole purpose of assisting tools and libraries.

```
kubectl describe pod annotations-demo

...
Annotations:      cni.projectcalico.org/containerID: 7004a4680d6d73201fe2856c81f4f6153e503fc7c3e942e974872376f3b43f7b
                  cni.projectcalico.org/podIP: 10.2.1.8/32
                  cni.projectcalico.org/podIPs: 10.2.1.8/32
                  imageregistry: https://hub.docker.com/
```