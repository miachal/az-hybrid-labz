#### Task 1. Checking kubectl and cluster status.

Na potrzeby tego ćwiczenia został utworzony cluster k8s na linode.com.
```
Version: 1.23
Frankfurt, DE
3 CPU Cores, 6 GB RAM, 150 GB Storage
```
```
> export KUBECONFIG=kubeconfig.yaml
```

```
> kubectl version

Client Version: version.Info{Major:"1", Minor:"25", GitVersion:"v1.25.3", GitCommit:"434bfd82814af038ad94d62ebe59b133fcb50506", GitTreeState:"clean", BuildDate:"2022-10-12T10:57:26Z", GoVersion:"go1.19.2", Compiler:"gc", Platform:"linux/amd64"}
Kustomize Version: v4.5.7
Server Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.10", GitCommit:"7e54d50d3012cf3389e43b096ba35300f36e0817", GitTreeState:"clean", BuildDate:"2022-08-17T18:26:59Z", GoVersion:"go1.17.13", Compiler:"gc", Platform:"linux/amd64"}
```

```
> kubectl get nodes

NAME                           STATUS   ROLES    AGE   VERSION
lke79380-122675-6369675b1613   Ready    <none>   95s   v1.23.6
lke79380-122675-6369675b7714   Ready    <none>   89s   v1.23.6
lke79380-122675-6369675bd241   Ready    <none>   86s   v1.23.6
```

#### Task 2. Creating a pod.

```
> kubectl run endzajneks --restart=Never --image=nginx:latest

pod/endzajneks created
```

```
> kubectl get pods

NAME         READY   STATUS    RESTARTS   AGE
endzajneks   1/1     Running   0          21s
```

#### Task 3. Editing and getting pod details.

```
> kubectl get pods endzajneks --export -o yaml > pod_definition.yaml

error: unknown flag: --export
See 'kubectl get --help' for usage.
```

Od wersji 1.14, **--export** jest deprecated.

```
> kubectl get pods endzajneks -o yaml > pod_definition.yaml
> ll pod_definition.yaml 
-rw-rw-r-- 1 miachal miachal 2796 lis  7 21:30 pod_definition.yaml
```

[pod_definition.yaml](pod_definition.yaml)

```
> kubectl edit pods endzajneks
kubectlpod/endzajneks edited

> kubectl get pods
NAME         READY   STATUS    RESTARTS   AGE
endzajneks   1/1     Running   0          11m

> kubectl describe pods endzajneks | grep -i nginx
    Image:          nginx:1.9.1
    Image ID:       docker-pullable://nginx@sha256:2f68b99bc0d6d25d0c56876b924ec20418544ff28e1fb89a4c27679a40da811b
  Normal  Pulling    11m               kubelet            Pulling image "nginx:latest"
  Normal  Pulled     11m               kubelet            Successfully pulled image "nginx:latest" in 10.581190708s
  Normal  Pulling    14s               kubelet            Pulling image "nginx:1.9.1"
  Normal  Pulled     1s                kubelet            Successfully pulled image "nginx:1.9.1" in 12.356399851s
```

```
> kubectl port-forward endzajneks 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80

> curl 127.0.0.1:8080
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

```
kubectl delete pods endzajneks
pod "endzajneks" deleted

> kubectl get pods
No resources found in default namespace.

/*
    --grace-period=-1:
	Period of time in seconds given to the resource to terminate gracefully. Ignored if negative. Set to 1 for
	immediate shutdown. Can only be set to 0 when --force is true (force deletion).
*/
```

#### Task 4. Creating and editing a pod using manifest file.

[pod_manifest.yaml](pod_manifest.yaml)

```
> kubectl create -f pod_manifest.yaml 
pod/my-pod created

> kubectl get pods
NAME     READY   STATUS    RESTARTS   AGE
my-pod   1/1     Running   0          4s
```

```
> sed -i 's/app: myapp/app: myapp-2/' pod_manifest.yaml

> kubectl apply -f pod_manifest.yaml 
Warning: resource pods/my-pod is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
pod/my-pod configured
```

Poleciał warning, ale labelka została zmieniona. W eventach nie ma informacji o zmianie. :(
```
> kubectl describe pods my-pod | grep -i labels
Labels:           app=myapp-2
```

#### Task 5. Examining pod logs and running a command inside the pod.

```
> kubectl logs my-pod
Welcome to k8s!
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
2: tunl0@NONE: <NOARP> mtu 1480 qdisc noop qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
4: eth0@if8: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1480 qdisc noqueue 
    link/ether 72:08:ce:0a:04:81 brd ff:ff:ff:ff:ff:ff
    inet 10.2.2.2/32 scope global eth0
       valid_lft forever preferred_lft forever
```

```
> kubectl delete pods my-pod
pod "my-pod" deleted
```

Yay. :)