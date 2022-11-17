#### Task 1. Create a deployment to rollout a replicaset

```
> kubectl apply -f depl.yaml 
deployment.apps/nginx-deployment created

> kubectl get deployments
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           15s
```

#### Task 2. Examining the deployment

```
> kubectl rollout status deployment nginx-deployment
deployment "nginx-deployment" successfully rolled out

> kubectl get deployments
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           4m23s

> kubectl rollout status deployment nginx-deployment
deployment "nginx-deployment" successfully rolled out

> kubectl rollout history deployment nginx-deployment
deployment.apps/nginx-deployment 
REVISION  CHANGE-CAUSE
1         <none>
```

```
> kubectl get pods --show-labels
NAME                               READY   STATUS    RESTARTS   AGE     LABELS
nginx-deployment-f7ccf9478-9n9gg   1/1     Running   0          9m31s   app=nginx,pod-template-hash=f7ccf9478
nginx-deployment-f7ccf9478-d8k7v   1/1     Running   0          9m31s   app=nginx,pod-template-hash=f7ccf9478
nginx-deployment-f7ccf9478-k2l9k   1/1     Running   0          9m31s   app=nginx,pod-template-hash=f7ccf9478
```

```
> kubectl port-forward nginx-deployment-f7ccf9478-k2l9k 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
Handling connection for 8080

(2)> curl localhost:8080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
<p><em>Thank you for using nginx.</em></p>
</body>
</html>

(2)> curl -I -X GET localhost:8080
HTTP/1.1 200 OK
Server: nginx/1.7.9
Date: Thu, 17 Nov 2022 16:26:36 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 23 Dec 2014 16:25:09 GMT
Connection: keep-alive
ETag: "54999765-264"
Accept-Ranges: bytes
```

#### Task 3. Updating the deployment

```
> kubectl --record deployment.apps/nginx-deployment set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1
deployment.apps/nginx-deployment image updated
deployment.apps/nginx-deployment image updated

> kubectl rollout status deployment.v1.apps/nginx-deployment
deployment "nginx-deployment" successfully rolled out

> kubectl get deployments
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           14m

> kubectl get deployment.v1.apps
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           14m

> kubectl get rs
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-5bfdf46dc6   3         3         3       48s
nginx-deployment-f7ccf9478    0         0         0       14m
```

```
> kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-5bfdf46dc6-9rc7n   1/1     Running   0          5m17s
nginx-deployment-5bfdf46dc6-brvfk   1/1     Running   0          5m5s
nginx-deployment-5bfdf46dc6-f52rj   1/1     Running   0          5m6s

> kubectl port-forward nginx-deployment-5bfdf46dc6-f52rj 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080

(2)> curl -I -X GET localhost:8080
HTTP/1.1 200 OK
Server: nginx/1.9.1
Date: Thu, 17 Nov 2022 16:34:51 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 26 May 2015 15:02:09 GMT
Connection: keep-alive
ETag: "55648af1-264"
Accept-Ranges: bytes
```

```
> kubectl apply -f depl2.yaml 
deployment.apps/nginx-deployment configured

> kubectl get pods
NAME                                READY   STATUS              RESTARTS   AGE
nginx-deployment-54f7cd5bc7-4lgqt   0/1     ContainerCreating   0          6s
nginx-deployment-54f7cd5bc7-hn98h   0/1     ContainerCreating   0          6s
nginx-deployment-5bfdf46dc6-9rc7n   1/1     Running             0          10m
nginx-deployment-5bfdf46dc6-brvfk   1/1     Running             0          10m
nginx-deployment-5bfdf46dc6-f52rj   1/1     Running             0          10m
nginx-deployment-5bfdf46dc6-ntbr6   1/1     Running             0          6s

> kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-54f7cd5bc7-4lgqt   1/1     Running   0          18s
nginx-deployment-54f7cd5bc7-5ngtc   1/1     Running   0          11s
nginx-deployment-54f7cd5bc7-hn98h   1/1     Running   0          18s
nginx-deployment-54f7cd5bc7-jbnp2   1/1     Running   0          11s
nginx-deployment-54f7cd5bc7-jv7r6   1/1     Running   0          7s
```

#### Task 4. Managing Rollout History

```
> kubectl rollout history deployment nginx-deployment
deployment.apps/nginx-deployment 
REVISION  CHANGE-CAUSE
1         <none>
2         kubectl deployment.apps/nginx-deployment set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1 --record=true
3         Image change

> kubectl rollout history deployment nginx-deployment --revision=2
deployment.apps/nginx-deployment with revision #2
Pod Template:
  Labels:       app=nginx
        pod-template-hash=5bfdf46dc6
  Annotations:  kubernetes.io/change-cause:
          kubectl deployment.apps/nginx-deployment set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1 --record=true
  Containers:
   nginx:
    Image:      nginx:1.9.1
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:        <none>
    Mounts:     <none>
  Volumes:      <none>

> kubectl rollout history deployment nginx-deployment --revision=3
deployment.apps/nginx-deployment with revision #3
Pod Template:
  Labels:       app=nginx
        pod-template-hash=54f7cd5bc7
  Annotations:  kubernetes.io/change-cause: Image change
  Containers:
   nginx:
    Image:      nginx:1.17.3
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:        <none>
    Mounts:     <none>
  Volumes:      <none>
```

```
> kubectl rollout undo deployments nginx-deployment
deployment.apps/nginx-deployment rolled back

> kubectl rollout history deployment nginx-deployment
deployment.apps/nginx-deployment 
REVISION  CHANGE-CAUSE
1         <none>
3         Image change
4         kubectl deployment.apps/nginx-deployment set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1 --record=true

> kubectl rollout history deployment nginx-deployment --revision=4
deployment.apps/nginx-deployment with revision #4
Pod Template:
  Labels:       app=nginx
        pod-template-hash=5bfdf46dc6
  Annotations:  kubernetes.io/change-cause:
          kubectl deployment.apps/nginx-deployment set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1 --record=true
  Containers:
   nginx:
    Image:      nginx:1.9.1
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:        <none>
    Mounts:     <none>
  Volumes:      <none>

> kubectl rollout history deployment nginx-deployment --revision=2
error: unable to find the specified revision
```

```
> kubectl rollout undo deployments nginx-deployment --to-revision=3
deployment.apps/nginx-deployment rolled back

> kubectl rollout history deployment nginx-deployment
deployment.apps/nginx-deployment 
REVISION  CHANGE-CAUSE
1         <none>
4         kubectl deployment.apps/nginx-deployment set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1 --record=true
5         Image change
```

```
> kubectl delete deployment nginx-deployment
deployment.apps "nginx-deployment" deleted
```