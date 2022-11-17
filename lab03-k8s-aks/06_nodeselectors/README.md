#### Task 0. Prepare for battle!
```
> kubectl get nodes
NAME                                STATUS   ROLES   AGE    VERSION
aks-agentpool-10697719-vmss000000   Ready    agent   3h9m   v1.23.12
```

```
> az aks nodepool list -g wsb-lab03 --cluster-name wsb-k8s -o table
Name       OsType    KubernetesVersion    VmSize        Count    MaxPods    ProvisioningState    Mode
---------  --------  -------------------  ------------  -------  ---------  -------------------  ------
agentpool  Linux     1.23.12              Standard_B2s  1        110        Succeeded            System

> az aks nodepool scale --cluster-name wsb-k8s -n agentpool -g wsb-lab03 -c 2
{...}

> az aks nodepool list -g wsb-lab03 --cluster-name wsb-k8s -o table
Name       OsType    KubernetesVersion    VmSize        Count    MaxPods    ProvisioningState    Mode
---------  --------  -------------------  ------------  -------  ---------  -------------------  ------
agentpool  Linux     1.23.12              Standard_B2s  2        110        Succeeded            System

```

#### Task 1. Adding labels to cluster nodes

```
> kubectl get nodes
NAME                                STATUS   ROLES   AGE     VERSION
aks-agentpool-10697719-vmss000000   Ready    agent   3h28m   v1.23.12
aks-agentpool-10697719-vmss000001   Ready    agent   4m9s    v1.23.12
```

```
> kubectl label nodes aks-agentpool-10697719-vmss000000 type=prod
node/aks-agentpool-10697719-vmss000000 labeled

> kubectl label nodes aks-agentpool-10697719-vmss000001 type=dev
node/aks-agentpool-10697719-vmss000001 labeled

> kubectl get nodes --show-labels
NAME                                STATUS   ROLES   AGE     VERSION    LABELS
aks-agentpool-10697719-vmss000000   Ready    agent   3h31m   v1.23.12   (...),type=prod
aks-agentpool-10697719-vmss000001   Ready    agent   7m22s   v1.23.12   (...),type=dev
```

#### Task 2. Creating ReplicaSet of nginx Pods

```
> kubectl create -f replica_set.yaml
replicaset.apps/frontend created

 kubectl get pods -o wide
NAME             READY   STATUS    RESTARTS   AGE   IP            NODE                                NOMINATED NODE   READINESS GATES
frontend-8tkkx   1/1     Running   0          13s   10.244.1.3    aks-agentpool-10697719-vmss000001   <none>           <none>
frontend-csgtm   1/1     Running   0          13s   10.244.0.30   aks-agentpool-10697719-vmss000000   <none>           <none>
frontend-q65fm   1/1     Running   0          13s   10.244.1.2    aks-agentpool-10697719-vmss000001   <none>           <none>
> 
```

#### Task 3. Creating ReplicaSet of nginx Pods on prod node

```
> kubectl create -f replica_set_node_selector.yaml 
replicaset.apps/frontend-selector created

> kubectl get pods -o wide
NAME                      READY   STATUS    RESTARTS   AGE     IP            NODE                                NOMINATED NODE   READINESS GATES
frontend-8tkkx            1/1     Running   0          2m13s   10.244.1.3    aks-agentpool-10697719-vmss000001   <none>           <none>
frontend-csgtm            1/1     Running   0          2m13s   10.244.0.30   aks-agentpool-10697719-vmss000000   <none>           <none>
frontend-q65fm            1/1     Running   0          2m13s   10.244.1.2    aks-agentpool-10697719-vmss000001   <none>           <none>
frontend-selector-cjck6   1/1     Running   0          5s      10.244.0.32   aks-agentpool-10697719-vmss000000   <none>           <none>
frontend-selector-j9v6b   1/1     Running   0          5s      10.244.0.31   aks-agentpool-10697719-vmss000000   <none>           <none>
frontend-selector-r9rpc   1/1     Running   0          5s      10.244.0.33   aks-agentpool-10697719-vmss000000   <none>           <none>
``` 

#### Task 4. Clear me

```
> kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
frontend-8tkkx            1/1     Running   0          6m5s
frontend-csgtm            1/1     Running   0          6m5s
frontend-q65fm            1/1     Running   0          6m5s
frontend-selector-cjck6   1/1     Running   0          3m57s
frontend-selector-j9v6b   1/1     Running   0          3m57s
frontend-selector-r9rpc   1/1     Running   0          3m57s

> kubectl delete -f replica_set.yaml 
replicaset.apps "frontend" deleted

> kubectl delete -f replica_set_node_selector.yaml 
replicaset.apps "frontend-selector" deleted

> kubectl get pods
No resources found in default namespace.

> az aks nodepool scale --cluster-name wsb-k8s -n agentpool -g wsb-lab03 -c 1
{...}

> az aks nodepool list -g wsb-lab03 --cluster-name wsb-k8s -o table
Name       OsType    KubernetesVersion    VmSize        Count    MaxPods    ProvisioningState    Mode
---------  --------  -------------------  ------------  -------  ---------  -------------------  ------
agentpool  Linux     1.23.12              Standard_B2s  1        110        Succeeded            System
```
