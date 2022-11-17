#### Task 1. Creating pods with labels

```
> kubectl create -f pod_labels.yaml 
pod/nginx-prod created
pod/nginx-test created
pod/nginx-dev created

> kubectl get pods --show-labels
NAME         READY   STATUS    RESTARTS   AGE   LABELS
nginx-dev    1/1     Running   0          7s    app=myapp,environment=dev,tier=frontend,version=1.2.0
nginx-prod   1/1     Running   0          7s    app=myapp,environment=production,tier=frontend,version=1.0.0
nginx-test   1/1     Running   0          7s    app=myapp,environment=test,tier=frontend,version=1.1.0
```

#### Task 2. Modifying labels

```
> kubectl create -f pod_labels.yaml 
pod/nginx-prod created
pod/nginx-test created
pod/nginx-dev created

> kubectl get pods --show-labels
NAME         READY   STATUS    RESTARTS   AGE   LABELS
nginx-dev    1/1     Running   0          7s    app=myapp,environment=dev,tier=frontend,version=1.2.0
nginx-prod   1/1     Running   0          7s    app=myapp,environment=production,tier=frontend,version=1.0.0
nginx-test   1/1     Running   0          7s    app=myapp,environment=test,tier=frontend,version=1.1.0

> kubectl label pod nginx-dev "isDev=true"
pod/nginx-dev labeled

> kubectl get pods --show-labels
NAME         READY   STATUS    RESTARTS   AGE     LABELS
nginx-dev    1/1     Running   0          2m21s   app=myapp,environment=dev,isDev=true,tier=frontend,version=1.2.0
nginx-prod   1/1     Running   0          2m21s   app=myapp,environment=production,tier=frontend,version=1.0.0
nginx-test   1/1     Running   0          2m21s   app=myapp,environment=test,tier=frontend,version=1.1.0

> kubectl get pods --show-labels -l isDev=true
NAME        READY   STATUS    RESTARTS   AGE     LABELS
nginx-dev   1/1     Running   0          2m30s   app=myapp,environment=dev,isDev=true,tier=frontend,version=1.2.0

> kubectl label pod nginx-dev "isDev-"
pod/nginx-dev unlabeled

> kubectl get pods --show-labels -l isDev=true
No resources found in default namespace.

> kubectl get pods --show-labels
NAME         READY   STATUS    RESTARTS   AGE     LABELS
nginx-dev    1/1     Running   0          2m55s   app=myapp,environment=dev,tier=frontend,version=1.2.0
nginx-prod   1/1     Running   0          2m55s   app=myapp,environment=production,tier=frontend,version=1.0.0
nginx-test   1/1     Running   0          2m55s   app=myapp,environment=test,tier=frontend,version=1.1.0
```

#### Task 3. Label selectors

```
> kubectl get pods --selector="environment=production" --show-labels
NAME         READY   STATUS    RESTARTS   AGE   LABELS
nginx-prod   1/1     Running   0          28m   app=myapp,environment=production,tier=frontend,version=1.0.0

> kubectl get pods --selector="environment in (production, test)" --show-labels
NAME         READY   STATUS    RESTARTS   AGE   LABELS
nginx-prod   1/1     Running   0          28m   app=myapp,environment=production,tier=frontend,version=1.0.0
nginx-test   1/1     Running   0          28m   app=myapp,environment=test,tier=frontend,version=1.1.0

> kubectl get pods --selector="environment notin (production, test)" --show-labels
NAME        READY   STATUS    RESTARTS   AGE   LABELS
nginx-dev   1/1     Running   0          28m   app=myapp,environment=dev,tier=frontend,version=1.2.0

> kubectl get pods --selector="environment!=production" --show-labels
NAME         READY   STATUS    RESTARTS   AGE   LABELS
nginx-dev    1/1     Running   0          28m   app=myapp,environment=dev,tier=frontend,version=1.2.0
nginx-test   1/1     Running   0          28m   app=myapp,environment=test,tier=frontend,version=1.1.0

> kubectl delete -f pod_labels.yaml 
pod "nginx-prod" deleted
pod "nginx-test" deleted
pod "nginx-dev" deleted
```

#### Task 4. Annotations

```
> kubectl create -f pod_annotation.yaml 
pod/annotations-demo created

> kubectl get pods
NAME               READY   STATUS    RESTARTS   AGE
annotations-demo   1/1     Running   0          12s

> kubectl describe pod annotations-demo
Name:             annotations-demo
...
Annotations:      imageregistry: https://hub.docker.com/
...
```