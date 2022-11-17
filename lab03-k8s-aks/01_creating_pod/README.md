#### Task 1. Checking kubectl and cluster status

```
> kubectl version
Client Version: version.Info{Major:"1", Minor:"25", GitVersion:"v1.25.3", GitCommit:"434bfd82814af038ad94d62ebe59b133fcb50506", GitTreeState:"clean", BuildDate:"2022-10-12T10:57:26Z", GoVersion:"go1.19.2", Compiler:"gc", Platform:"linux/amd64"}
Kustomize Version: v4.5.7
Server Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.12", GitCommit:"f941a31f4515c5ac03f5fc7ccf9a330e3510b80d", GitTreeState:"clean", BuildDate:"2022-11-09T17:12:33Z", GoVersion:"go1.17.13", Compiler:"gc", Platform:"linux/amd64"}
WARNING: version difference between client (1.25) and server (1.23) exceeds the supported minor version skew of +/-1

> kubectl get nodes
NAME                                STATUS   ROLES   AGE   VERSION
aks-agentpool-10697719-vmss000000   Ready    agent   12m   v1.23.12
```

#### Task 2. Creating a pod

```
> kubectl run my-nginx --restart=Never --image=nginx:1.7.9
pod/my-nginx created

> kubectl get pods -w
NAME       READY   STATUS              RESTARTS   AGE
my-nginx   0/1     ContainerCreating   0          5s
my-nginx   1/1     Running             0          9s
```

#### Task 3. Editing and getting pod details

```
> kubectl describe pods my-nginx -o yaml > my_pod_definition.yaml
```

```
> kubectl edit pod my-nginx
pod/my-nginx edited

> kubectl describe pod my-nginx
...
Containers:
  my-nginx:
    Container ID:   containerd://e21847267c1cf1679b47aa5b32afa73a4b550c63a063e1e0b07980ac6f5d1904
    Image:          nginx:1.9.1
    ...
...
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  ...
  Normal  Killing    10s    kubelet            Container my-nginx definition changed, will be restarted
  Normal  Pulling    10s    kubelet            Pulling image "nginx:1.9.1"
  Normal  Pulled     1s     kubelet            Successfully pulled image "nginx:1.9.1" in 8.737766233s
```

```
> kubectl delete pod my-nginx --grace-period=1
pod "my-nginx" deleted

> kubectl get pods
No resources found in default namespace.
```


#### Task 4. Creating and editing a pod using manifest file

```
> kubectl create -f pod_definition.yaml 
pod/my-pod created

> kubectl get pods
NAME     READY   STATUS    RESTARTS   AGE
my-pod   1/1     Running   0          4s
```

```
> sed -i 's/app: myapp/app: myapp-2/' pod_definition.yaml 

> kubectl apply -f pod_definition.yaml
pod/my-pod configured

> kubectl describe pod my-pod | grep -i label
Labels:           app=myapp-2
```

```
Note:  
Warning: resource pods/my-pod is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
```

```
> kubectl port-forward my-nginx 8080:80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080

> curl localhost:8080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

#### Task 5. Examining pod logs and running a command inside the pod

```
> kubectl logs my-pod
Welcome to Kubernetes!
```

```
> kubectl exec my-pod -- cat /etc/passwd
root:x:0:0:root:/root:/bin/sh
daemon:x:1:1:daemon:/usr/sbin:/bin/false
bin:x:2:2:bin:/bin:/bin/false
sys:x:3:3:sys:/dev:/bin/false
sync:x:4:100:sync:/bin:/bin/sync
mail:x:8:8:mail:/var/spool/mail:/bin/false
www-data:x:33:33:www-data:/var/www:/bin/false
operator:x:37:37:Operator:/var:/bin/false
nobody:x:65534:65534:nobody:/home:/bin/false
```

```
> kubectl exec my-pod -it -- /bin/sh
/ # whoami
root
/ # ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0@if14: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue 
    link/ether e6:e3:b2:88:6e:c8 brd ff:ff:ff:ff:ff:ff
    inet 10.244.0.12/24 brd 10.244.0.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::e4e3:b2ff:fe88:6ec8/64 scope link 
       valid_lft forever preferred_lft forever
```

```
> kubectl delete pod my-pod
pod "my-pod" deleted
```