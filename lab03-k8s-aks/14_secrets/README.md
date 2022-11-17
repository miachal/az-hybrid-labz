#### Task 1. Creating a secret from files

```
> mkdir secret

> cd secret/

> echo -n 'admin' > username.txt
> echo -n 'p@$$woRd' > password.txt

> kubectl create secret generic user-pass --from-file=./username.txt --from-file=./password.txt
secret/user-pass created

> kubectl get secrets
NAME                  TYPE                                  DATA   AGE
default-token-fsc9r   kubernetes.io/service-account-token   3      106m
user-pass             Opaque                                2      7s

> kubectl describe secret user-pass
Name:         user-pass
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
password.txt:  8 bytes
username.txt:  5 bytes
> kubectl get secret user-pass -o yaml
apiVersion: v1
data:
  password.txt: cEAkJHdvUmQ=
  username.txt: YWRtaW4=
kind: Secret
metadata:
  creationTimestamp: "2022-11-17T17:18:04Z"
  name: user-pass
  namespace: default
  resourceVersion: "24562"
  uid: 6b82e0fd-f6b5-41ad-9aa7-48a84d32c66d
type: Opaque

> echo 'cEAkJHdvUmQ=' | base64 --decode
p@$$woRd
> echo 'YWRtaW4=' | base64 --decode
admin
```

#### Task 2. Creating secret using a manifest file

```
> kubectl apply -f secret.yaml 
secret/mysecret created

> kubectl describe secret mysecret
Name:         mysecret
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
password:  12 bytes
> kubectl get secret mysecret -o yaml
apiVersion: v1
data:
  password: cGFzc3dvcmQxMjM0
kind: Secret
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Secret","metadata":{"annotations":{},"name":"mysecret","namespace":"default"},"stringData":{"password":"password1234"},"type":"Opaque"}
  creationTimestamp: "2022-11-17T17:21:44Z"
  name: mysecret
  namespace: default
  resourceVersion: "25352"
  uid: fb8c4d34-da4e-49ce-83ab-648518fccc23
type: Opaque

> echo 'cGFzc3dvcmQxMjM0' | base64 --decode
password123
```

#### Task 3. Using secret from a pod as a volume

```
> kubectl apply -f pod-volume.yaml 
pod/mypod created

> kubectl logs mypod
password

> kubectl exec mypod -it -- /bin/sh
/ # cd /etc/foo/

/etc/foo # ls
password

/etc/foo # cat password 
password1234
```

#### Task 4. Using secrets as environment variables

```
> kubectl apply -f pod-env.yaml 
pod/secret-env-pod created

> kubectl logs secret-env-pod
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT=tcp://10.0.0.1:443
HOSTNAME=secret-env-pod
SHLVL=1
HOME=/root
SECRET_PASSWORD=password1234
KUBERNETES_PORT_443_TCP_ADDR=10.0.0.1
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_PROTO=tcp
SECRET_USERNAME=password1234
KUBERNETES_PORT_443_TCP=tcp://10.0.0.1:443
KUBERNETES_SERVICE_PORT_HTTPS=443
PWD=/
KUBERNETES_SERVICE_HOST=10.0.0.1

> kubectl delete pod secret-env-pod
pod "secret-env-pod" deleted

> kubectl get secrets
NAME                  TYPE                                  DATA   AGE
default-token-fsc9r   kubernetes.io/service-account-token   3      126m
mysecret              Opaque                                1      16m
user-pass             Opaque                                2      20m

> kubectl delete secret mysecret
secret "mysecret" deleted

> kubectl delete secret user-pass
secret "user-pass" deleted
```