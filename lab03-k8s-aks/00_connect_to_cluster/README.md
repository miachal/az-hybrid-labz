#### Task 0. Creating a cluster

```
> az group list -o table | grep -i wsb
wsb-lab03                        westeurope          Succeeded

> az aks list
[]
```

```
> az deployment group create -g wsb-lab03 -n aks_deployment --template-file template.json --parameters @parameters.json
```


```
> az aks list -o table
Name     Location    ResourceGroup    KubernetesVersion    CurrentKubernetesVersion    ProvisioningState    Fqdn
-------  ----------  ---------------  -------------------  --------------------------  -------------------  ---------------------------------------------
wsb-k8s  westeurope  wsb-lab03        1.23.12              1.23.12                     Succeeded            wsb-k8s-dns-3eefea6a.hcp.westeurope.azmk8s.io
```

#### Task 1. Connect to the cluster

```
> az aks get-credentials -g wsb-lab03 -n wsb-k8s -f ./kubusconfig.yaml
Merged "wsb-k8s" as current context in ./kubusconfig.yaml

> export KUBECONFIG=$(pwd)/kubusconfig.yaml

> kubectl cluster-info
Kubernetes control plane is running at https://wsb-k8s-dns-3eefea6a.hcp.westeurope.azmk8s.io:443
CoreDNS is running at https://wsb-k8s-dns-3eefea6a.hcp.westeurope.azmk8s.io:443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://wsb-k8s-dns-3eefea6a.hcp.westeurope.azmk8s.io:443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy
```