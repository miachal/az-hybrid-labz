#### Task 1. Creating a ConfigMap from literal

```
> kubectl create configmap my-config-map --from-literal=key1=value1 --from-literal=key2=value2
configmap/my-config-map created

> kubectl get configmap my-config-map -o yaml
apiVersion: v1
data:
  key1: value1
  key2: value2
kind: ConfigMap
metadata:
  creationTimestamp: "2022-11-17T16:52:23Z"
  name: my-config-map
  namespace: default
  resourceVersion: "18992"
  uid: 114c40de-b761-47a7-a47f-fdbb9cafa9bc
```

#### Task 2. Creating a ConfigMap from directories and files

```
> kubectl get cm
NAME               DATA   AGE
kube-root-ca.crt   1      81m
my-config-map      2      38s

> kubectl create configmap my-config-map-2 --from-file=.
configmap/my-config-map-2 created

> kubectl get configmap my-config-map-2 -o yaml
apiVersion: v1
data:
  params1.txt: |
    key11=value1
    key12=value2
    key13=value3
  params2.txt: |
    key21=value1
    key22=value2
    key23=value3
kind: ConfigMap
metadata:
  creationTimestamp: "2022-11-17T16:55:06Z"
  name: my-config-map-2
  namespace: default
  resourceVersion: "19581"
  uid: df035209-fe2b-4579-b307-027201a79ca9
```

```
> kubectl create configmap my-config-map-3 --from-file=params2.txt
configmap/my-config-map-3 created

> kubectl get cm my-config-map-3 -o yaml
apiVersion: v1
data:
  params2.txt: |
    key21=value1
    key22=value2
    key23=value3
kind: ConfigMap
metadata:
  creationTimestamp: "2022-11-17T16:55:59Z"
  name: my-config-map-3
  namespace: default
  resourceVersion: "19769"
  uid: c7375f82-3a70-4ffd-831a-389ed91eb71d

> kubectl get cm
NAME               DATA   AGE
kube-root-ca.crt   1      84m
my-config-map      2      3m55s
my-config-map-2    2      72s
my-config-map-3    1      19s
```

#### Task 3. Creating ConfigMap using manifest file

```
> kubectl apply -f cm.yaml 
configmap/my-config-map-4 created
configmap/my-config-map-5 created

> kubectl get cm
NAME               DATA   AGE
kube-root-ca.crt   1      85m
my-config-map      2      4m49s
my-config-map-2    2      2m6s
my-config-map-3    1      73s
my-config-map-4    1      5s
my-config-map-5    1      5s

> kubectl get cm my-config-map-4 -o yaml
apiVersion: v1
data:
  special.how: very
kind: ConfigMap
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","data":{"special.how":"very"},"kind":"ConfigMap","metadata":{"annotations":{},"name":"my-config-map-4","namespace":"default"}}
  creationTimestamp: "2022-11-17T16:57:07Z"
  name: my-config-map-4
  namespace: default
  resourceVersion: "20015"
  uid: a269602e-7bc7-4eac-9992-d6cc8c8cdb13

> kubectl get cm my-config-map-5 -o yaml
apiVersion: v1
data:
  log_level: INFO
kind: ConfigMap
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","data":{"log_level":"INFO"},"kind":"ConfigMap","metadata":{"annotations":{},"name":"my-config-map-5","namespace":"default"}}
  creationTimestamp: "2022-11-17T16:57:07Z"
  name: my-config-map-5
  namespace: default
  resourceVersion: "20016"
  uid: 40b1e618-7a21-41a4-b77b-88978b2de3c1
```

#### Task 4. Using ConfigMap as container environment variables

```
> kubectl apply -f pod.yaml 
pod/dapi-test-pod created

> kubectl logs dapi-test-pod
KUBERNETES_PORT=tcp://10.0.0.1:443
KUBERNETES_SERVICE_PORT=443
LOG_LEVEL=INFO
HOSTNAME=dapi-test-pod
SHLVL=1
HOME=/root
KUBERNETES_PORT_443_TCP_ADDR=10.0.0.1
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_PROTO=tcp
SPECIAL_LEVEL_KEY=very
KUBERNETES_PORT_443_TCP=tcp://10.0.0.1:443
KUBERNETES_SERVICE_PORT_HTTPS=443
PWD=/
KUBERNETES_SERVICE_HOST=10.0.0.1

> kubectl get cm my-config-map-5 -o yaml
apiVersion: v1
data:
  log_level: INFO
kind: ConfigMap
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","data":{"log_level":"INFO"},"kind":"ConfigMap","metadata":{"annotations":{},"name":"my-config-map-5","namespace":"default"}}
  creationTimestamp: "2022-11-17T16:57:07Z"
  name: my-config-map-5
  namespace: default
  resourceVersion: "20016"
  uid: 40b1e618-7a21-41a4-b77b-88978b2de3c1

> kubectl delete pod dapi-test-pod
pod "dapi-test-pod" deleted
```

#### Task 5. Adding ConfigMap data to a volume

```
> kubectl apply -f pod-files.yaml 
pod/dapi-test-pod created

> kubectl logs dapi-test-pod
map2
map3

> kubectl exec dapi-test-pod -it -- /bin/sh
/ # cd /etc/config

/etc/config # ls
map2  map3

/etc/config # ls map2/
..2022_11_17_17_08_16.93406683/  params1.txt
..data/                          params2.txt

/etc/config # cat map2/params*
key11=value1
key12=value2
key13=value3
key21=value1
key22=value2
key23=value3
```