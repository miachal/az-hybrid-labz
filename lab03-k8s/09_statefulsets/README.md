#### Task 1. Creating a StatefulSet

```
(2) > kubectl get pods -w -l app=nginx
NAME    READY   STATUS    RESTARTS   AGE
web-0   0/1     Pending   0          0s
web-0   0/1     Pending   0          0s
web-0   0/1     Pending   0          7s
web-0   0/1     ContainerCreating   0          7s
web-0   0/1     ContainerCreating   0          29s
web-0   1/1     Running             0          38s
web-1   0/1     Pending             0          0s
web-1   0/1     Pending             0          0s
web-1   0/1     Pending             0          6s
web-1   0/1     ContainerCreating   0          6s
web-1   0/1     ContainerCreating   0          29s
web-1   1/1     Running             0          34s
```

#### Task 2. Examining Pods Network Identifies

```
> for i in 0 1; do kubectl exec web-$i -- sh -c 'hostname'; done
web-0
web-1
```

```
> kubectl run -i --tty --image=busybox:1.28 dns-test --restart=Never --rm
If you don't see a command prompt, try pressing enter.
/ # nslookup web-0.nginx
Server:    10.128.0.10
Address 1: 10.128.0.10 kube-dns.kube-system.svc.cluster.local

Name:      web-0.nginx
Address 1: 10.2.2.22 web-0.nginx.default.svc.cluster.local
/ # nslookup web-1.nginx
Server:    10.128.0.10
Address 1: 10.128.0.10 kube-dns.kube-system.svc.cluster.local

Name:      web-1.nginx
Address 1: 10.2.1.33 web-1.nginx.default.svc.cluster.local
```

```
> kubectl delete statefulset web
statefulset.apps "web" deleted

(2) > kubectl get pods -w -l app=nginx
web-1   1/1     Terminating         0          9m26s
web-0   1/1     Terminating         0          10m
web-1   1/1     Terminating         0          9m26s
web-0   1/1     Terminating         0          10m
web-0   0/1     Terminating         0          10m
web-0   0/1     Terminating         0          10m
web-0   0/1     Terminating         0          10m
web-1   0/1     Terminating         0          9m28s
web-1   0/1     Terminating         0          9m28s
web-1   0/1     Terminating         0          9m28s
```

```
> kubectl run -i --tty --image=busybox:1.28 dns-test --restart=Never --rm
If you don't see a command prompt, try pressing enter.
/ # nslookup web-0.nginx
Server:    10.128.0.10
Address 1: 10.128.0.10 kube-dns.kube-system.svc.cluster.local

nslookup: can't resolve 'web-0.nginx'
/ # nslookup web-1.nginx
Server:    10.128.0.10
Address 1: 10.128.0.10 kube-dns.kube-system.svc.cluster.local

nslookup: can't resolve 'web-1.nginx'
```

#### Task 3. Writing to Stable Storage

```
> kubectl get pvc -l app=nginx
NAME        STATUS   VOLUME                 CAPACITY   ACCESS MODES   STORAGECLASS                  AGE
www-web-0   Bound    pvc-da6a4ad052844f37   10Gi       RWO            linode-block-storage-retain   26m
www-web-1   Bound    pvc-1ac8c3fb66d94e2e   10Gi       RWO            linode-block-storage-retain   26m
```

```
> for i in 0 1; do kubectl exec web-$i -- sh -c 'echo $(hostname) > /usr/share/nginx/html/index.html'; done
> for i in 0 1; do kubectl exec web-$i -- curl localhost; done
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     6  1web-0  0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
00     6    0     0    754      0 --:--:-- --:--:-- --:--:--   857

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     6  100     6    0     0    624   web-1--:--:-- --:--:-- --:--:--     0
   0 --:--:-- --:--:-- --:--:--   666
```

```
> kubectl exec web-0 -it -- /bin/sh
# curl localhost
web-0
```

```
> kubectl delete pod -l app=nginx

(2) > kubectl get pods -w -l app=nginx
web-0   1/1     Terminating         0          3m11s
web-1   1/1     Terminating         0          3m4s
web-0   1/1     Terminating         0          3m12s
web-1   1/1     Terminating         0          3m4s
web-1   0/1     Terminating         0          3m5s
web-0   0/1     Terminating         0          3m13s
web-1   0/1     Terminating         0          3m5s
web-1   0/1     Terminating         0          3m5s
web-0   0/1     Terminating         0          3m13s
web-0   0/1     Terminating         0          3m13s
web-0   0/1     Pending             0          0s
web-0   0/1     Pending             0          0s
web-0   0/1     ContainerCreating   0          0s
web-0   0/1     ContainerCreating   0          9s
web-0   1/1     Running             0          10s
web-1   0/1     Pending             0          0s
web-1   0/1     Pending             0          0s
web-1   0/1     ContainerCreating   0          0s
web-1   0/1     ContainerCreating   0          48s
web-1   1/1     Running             0          49s

> for i in 0 1; do kubectl exec web-$i -- curl localhost; done
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    web-0 0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
 6  100     6    0     0    487      0 --:--:-- --:--:-- --:--:--   500
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 web-1    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
    6  100     6    0     0    360      0 --:--:-- --:--:-- --:--:--   375
```

#### Task 4. Scaling the StatefulSet

```
> kubectl scale statefulset web --replicas=4
statefulset.apps/web scaled

(2) > kubectl get pods -w -l app=nginx
NAME    READY   STATUS    RESTARTS   AGE
web-0   1/1     Running   0          2m34s
web-1   1/1     Running   0          2m24s
web-2   0/1     Pending   0          0s
web-2   0/1     Pending   0          0s
web-2   0/1     Pending   0          6s
web-2   0/1     ContainerCreating   0          6s
web-2   0/1     ContainerCreating   0          18s
web-2   1/1     Running             0          25s
web-3   0/1     Pending             0          0s
web-3   0/1     Pending             0          0s
web-3   0/1     Pending             0          8s
web-3   0/1     ContainerCreating   0          8s
web-3   0/1     ContainerCreating   0          19s
web-3   1/1     Running             0          20s

> kubectl scale statefulset web --replicas=2
statefulset.apps/web scaled

 > kubectl get pods -w -l app=nginx
NAME    READY   STATUS    RESTARTS   AGE
web-0   1/1     Running   0          3m54s
web-1   1/1     Running   0          3m44s
web-2   1/1     Running   0          62s
web-3   1/1     Running   0          37s
web-3   1/1     Terminating   0          40s
web-3   1/1     Terminating   0          40s
web-3   0/1     Terminating   0          41s
web-3   0/1     Terminating   0          41s
web-3   0/1     Terminating   0          41s
web-2   1/1     Terminating   0          66s
web-2   1/1     Terminating   0          66s
web-2   0/1     Terminating   0          67s
web-2   0/1     Terminating   0          67s
web-2   0/1     Terminating   0          67s
```

```
> kubectl delete -f statefulset.yaml 
service "nginx" deleted
statefulset.apps "web" deleted
```