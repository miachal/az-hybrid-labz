#### Task 1. Adding labels to cluster nodes

```
> kubectl get nodes
NAME                           STATUS   ROLES    AGE   VERSION
lke79523-122899-636ab6e994e5   Ready    <none>   70m   v1.23.6
lke79523-122899-636ab6e9f474   Ready    <none>   71m   v1.23.6
lke79523-122899-636ab6ea576a   Ready    <none>   70m   v1.23.6
```

```
> kubectl label node lke79523-122899-636ab6e994e5 env=prod
node/lke79523-122899-636ab6e994e5 labeled
> kubectl label node lke79523-122899-636ab6e9f474 env=dev
node/lke79523-122899-636ab6e9f474 labeled
> kubectl label node lke79523-122899-636ab6ea576a env=test
node/lke79523-122899-636ab6ea576a labeled
> kubectl get nodes --show-labels
NAME                           STATUS   ROLES    AGE   VERSION   LABELS
lke79523-122899-636ab6e994e5   Ready    <none>   72m   v1.23.6   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=g6-standard-1,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/region=eu-central,kubernetes.io/arch=amd64,kubernetes.io/hostname=lke79523-122899-636ab6e994e5,kubernetes.io/os=linux,lke.linode.com/pool-id=122899,node.kubernetes.io/instance-type=g6-standard-1,topology.kubernetes.io/region=eu-central,topology.linode.com/region=eu-central,env=prod
lke79523-122899-636ab6e9f474   Ready    <none>   72m   v1.23.6   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=g6-standard-1,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/region=eu-central,kubernetes.io/arch=amd64,kubernetes.io/hostname=lke79523-122899-636ab6e9f474,kubernetes.io/os=linux,lke.linode.com/pool-id=122899,node.kubernetes.io/instance-type=g6-standard-1,topology.kubernetes.io/region=eu-central,topology.linode.com/region=eu-central,env=dev
lke79523-122899-636ab6ea576a   Ready    <none>   72m   v1.23.6   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=g6-standard-1,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/region=eu-central,kubernetes.io/arch=amd64,kubernetes.io/hostname=lke79523-122899-636ab6ea576a,kubernetes.io/os=linux,lke.linode.com/pool-id=122899,node.kubernetes.io/instance-type=g6-standard-1,topology.kubernetes.io/region=eu-central,topology.linode.com/region=eu-central,env=test
```

#### Task 2. Creating ReplicaSet of nginx pods

```
> kubectl apply -f replica_set.yaml 
replicaset.apps/frontend created

> kubectl get pods -o wide
NAME             READY   STATUS    RESTARTS   AGE   IP          NODE                           NOMINATED NODE   READINESS GATES
frontend-7vcrx   1/1     Running   0          6s    10.2.0.10   lke79523-122899-636ab6e9f474   <none>           <none>
frontend-8jckv   1/1     Running   0          6s    10.2.1.9    lke79523-122899-636ab6e994e5   <none>           <none>
frontend-vt8jn   1/1     Running   0          6s    10.2.2.6    lke79523-122899-636ab6ea576a   <none>           <none>
```

#### Task 3. Creating ReplicaSet of nginx pods on prod node

```
> kubectl apply -f replica_set_node_selector.yaml 
replicaset.apps/frontend-selector created

> kubectl get pods -o wide
NAME                      READY   STATUS    RESTARTS   AGE     IP          NODE                           NOMINATED NODE   READINESS GATES
frontend-7vcrx            1/1     Running   0          2m29s   10.2.0.10   lke79523-122899-636ab6e9f474   <none>           <none>
frontend-8jckv            1/1     Running   0          2m29s   10.2.1.9    lke79523-122899-636ab6e994e5   <none>           <none>
frontend-selector-4jl47   0/1     Pending   0          3s      <none>      <none>                         <none>           <none>
frontend-selector-gf8bm   0/1     Pending   0          3s      <none>      <none>                         <none>           <none>
frontend-selector-n5ddz   0/1     Pending   0          3s      <none>      <none>                         <none>           <none>
frontend-vt8jn            1/1     Running   0          2m29s   10.2.2.6    lke79523-122899-636ab6ea576a   <none>           <none>
```

No cóż - nie taki selector... :)

```
> kubectl edit rs frontend-selector
replicaset.apps/frontend-selector edited

selector:
    env=prod
```

```
> kubectl get pods -o wide
NAME                      READY   STATUS    RESTARTS   AGE     IP          NODE                           NOMINATED NODE   READINESS GATES
frontend-7vcrx            1/1     Running   0          5m39s   10.2.0.10   lke79523-122899-636ab6e9f474   <none>           <none>
frontend-8jckv            1/1     Running   0          5m39s   10.2.1.9    lke79523-122899-636ab6e994e5   <none>           <none>
frontend-selector-4jl47   0/1     Pending   0          3m13s   <none>      <none>                         <none>           <none>
frontend-selector-gf8bm   0/1     Pending   0          3m13s   <none>      <none>                         <none>           <none>
frontend-selector-n5ddz   0/1     Pending   0          3m13s   <none>      <none>                         <none>           <none>
frontend-vt8jn            1/1     Running   0          5m39s   10.2.2.6    lke79523-122899-636ab6ea576a   <none>           <none>
```

Suprajs, suprajs - no to spróbujmy przeskalować rs.

```
> kubectl scale rs frontend-selector --replicas=0
replicaset.apps/frontend-selector scaled

> kubectl scale rs frontend-selector --replicas=3
replicaset.apps/frontend-selector scaled

> kubectl get pods -o wide
NAME                      READY   STATUS    RESTARTS   AGE    IP          NODE                           NOMINATED NODE   READINESS GATES
frontend-7vcrx            1/1     Running   0          8m     10.2.0.10   lke79523-122899-636ab6e9f474   <none>           <none>
frontend-8jckv            1/1     Running   0          8m     10.2.1.9    lke79523-122899-636ab6e994e5   <none>           <none>
frontend-selector-dqd27   1/1     Running   0          119s   10.2.1.12   lke79523-122899-636ab6e994e5   <none>           <none>
frontend-selector-mfsr7   1/1     Running   0          119s   10.2.1.10   lke79523-122899-636ab6e994e5   <none>           <none>
frontend-selector-qqvgj   1/1     Running   0          119s   10.2.1.11   lke79523-122899-636ab6e994e5   <none>           <none>
frontend-vt8jn            1/1     Running   0          8m     10.2.2.6    lke79523-122899-636ab6ea576a   <none>           <none>
```

```
> kubectl delete -f replica_set.yaml 
replicaset.apps "frontend" deleted

> kubectl delete -f replica_set_node_selector.yaml 
replicaset.apps "frontend-selector" deleted

> kubectl get pods
No resources found in default namespace.
```

Yay. ;)