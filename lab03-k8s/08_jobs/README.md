#### Task 1. Creating a job

```
> kubectl get jobs
NAME   COMPLETIONS   DURATION   AGE
pi     0/1           19s        19s

> kubectl describe jobs pi
Name:             pi
Namespace:        default
Selector:         controller-uid=64a8d291-8690-4148-8839-a5f0876f09a8
Labels:           controller-uid=64a8d291-8690-4148-8839-a5f0876f09a8
                  job-name=pi
Annotations:      <none>
Parallelism:      1
Completions:      1
Completion Mode:  NonIndexed
Start Time:       Sat, 12 Nov 2022 22:39:39 +0100
Pods Statuses:    1 Active / 0 Succeeded / 1 Failed
Pod Template:
  Labels:  controller-uid=64a8d291-8690-4148-8839-a5f0876f09a8
           job-name=pi
  Containers:
   pi:
    Image:      perl
    Port:       <none>
    Host Port:  <none>
    Command:
      perl
      -Mbignum=bpi
      -wle
      print bpi(2000)
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:
  Type    Reason            Age   From            Message
  ----    ------            ----  ----            -------
  Normal  SuccessfulCreate  59s   job-controller  Created pod: pi-lhjrc
  Normal  SuccessfulCreate  20s   job-controller  Created pod: pi-7sgjh
```

#### Task 2. Examing results

```
> kubectl get pods
NAME       READY   STATUS   RESTARTS   AGE
pi-7sgjh   0/1     Error    0          6m9s
pi-f5rn8   0/1     Error    0          5m27s
pi-fpnxx   0/1     Error    0          4m47s
pi-lhjrc   0/1     Error    0          6m48s
pi-tfhw9   0/1     Error    0          5m47s
```

-,-'

```
> kubectl logs pi-tfhw9
Can't use an undefined value as an ARRAY reference at /usr/local/lib/perl5/5.36.0/Math/BigInt/Calc.pm line 1049.
```

[kubernetes/website/pull/34070](https://github.com/kubernetes/website/pull/34070)  
[kubernetes/website/issues/34073](https://github.com/kubernetes/website/issues/34073)

No to zmniejszmy ilość miejsc po przecinku do 1000.

```
> kubectl apply -f job_pi.yaml 
job.batch/pi created

> kubectl get jobs
NAME   COMPLETIONS   DURATION   AGE
pi     1/1           6s         24s

> kubectl get pods
NAME       READY   STATUS      RESTARTS   AGE
pi-92pj5   0/1     Completed   0          4s

> kubectl logs pi-92pj5
3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481117450284102701938521105559644622948954930381964428810975665933446128475648233786783165271201909145648566923460348610454326648213393607260249141273724587006606315588174881520920962829254091715364367892590360011330530548820466521384146951941511609433057270365759591953092186117381932611793105118548074462379962749567351885752724891227938183011949129833673362440656643086021394946395224737190702179860943702770539217176293176752384674818467669405132000568127145263560827785771342757789609173637178721468440901224953430146549585371050792279689258923542019956112129021960864034418159813629774771309960518707211349999998372978049951059731732816096318595024459455346908302642522308253344685035261931188171010003137838752886587533208381420617177669147303598253490428755468731159562863882353787593751957781857780532171226806613001927876611195909216420199

> kubectl delete job pi
job.batch "pi" deleted
```

#### 3. Creating CronJob

```
> kubectl describe cronjob hello
Name:                          hello
Namespace:                     default
Labels:                        <none>
Annotations:                   <none>
Schedule:                      */1 * * * *
Concurrency Policy:            Allow
Suspend:                       False
Successful Job History Limit:  3
Failed Job History Limit:      1
Starting Deadline Seconds:     <unset>
Selector:                      <unset>
Parallelism:                   <unset>
Completions:                   <unset>
Pod Template:
  Labels:  <none>
  Containers:
   hello:
    Image:      busybox
    Port:       <none>
    Host Port:  <none>
    Args:
      /bin/sh
      -c
      date; echo Welcome to the Kubernetes
    Environment:     <none>
    Mounts:          <none>
  Volumes:           <none>
Last Schedule Time:  Sat, 12 Nov 2022 23:24:00 +0100
Active Jobs:         <none>
Events:
  Type    Reason            Age                From                Message
  ----    ------            ----               ----                -------
  Normal  SuccessfulCreate  10m                cronjob-controller  Created job hello-27804854
  Normal  SawCompletedJob   10m                cronjob-controller  Saw completed job: hello-27804854, status: Complete
  Normal  SuccessfulCreate  9m39s              cronjob-controller  Created job hello-27804855
  Normal  SawCompletedJob   9m32s              cronjob-controller  Saw completed job: hello-27804855, status: Complete
  Normal  SuccessfulCreate  8m39s              cronjob-controller  Created job hello-27804856
  Normal  SawCompletedJob   8m34s              cronjob-controller  Saw completed job: hello-27804856, status: Complete
  Normal  SuccessfulCreate  7m39s              cronjob-controller  Created job hello-27804857
  Normal  SawCompletedJob   7m34s              cronjob-controller  Saw completed job: hello-27804857, status: Complete
  Normal  SuccessfulDelete  7m34s              cronjob-controller  Deleted job hello-27804854
  Normal  SuccessfulCreate  6m39s              cronjob-controller  Created job hello-27804858
  Normal  SawCompletedJob   6m34s              cronjob-controller  Saw completed job: hello-27804858, status: Complete
  Normal  SuccessfulDelete  6m34s              cronjob-controller  Deleted job hello-27804855
  Normal  SuccessfulCreate  5m39s              cronjob-controller  Created job hello-27804859
  Normal  SawCompletedJob   5m34s              cronjob-controller  Saw completed job: hello-27804859, status: Complete
  Normal  SuccessfulDelete  5m34s              cronjob-controller  Deleted job hello-27804856
  Normal  SuccessfulCreate  4m39s              cronjob-controller  Created job hello-27804860
  Normal  SawCompletedJob   4m35s              cronjob-controller  Saw completed job: hello-27804860, status: Complete
  Normal  SuccessfulDelete  4m35s              cronjob-controller  Deleted job hello-27804857
  Normal  SuccessfulCreate  3m39s              cronjob-controller  Created job hello-27804861
  Normal  SawCompletedJob   3m34s              cronjob-controller  Saw completed job: hello-27804861, status: Complete
  Normal  SuccessfulDelete  3m34s              cronjob-controller  Deleted job hello-27804858
  Normal  SuccessfulCreate  2m39s              cronjob-controller  Created job hello-27804862
  Normal  SawCompletedJob   2m35s              cronjob-controller  Saw completed job: hello-27804862, status: Complete
  Normal  SuccessfulDelete  2m35s              cronjob-controller  Deleted job hello-27804859
  Normal  SuccessfulCreate  99s                cronjob-controller  (combined from similar events): Created job hello-27804863
  Normal  SawCompletedJob   34s (x2 over 95s)  cronjob-controller  (combined from similar events): Saw completed job: hello-27804864, status: Complete
  
> kubectl get pods
NAME                   READY   STATUS      RESTARTS   AGE
hello-27804863-skm92   0/1     Completed   0          2m39s
hello-27804864-z2r2k   0/1     Completed   0          99s
hello-27804865-xp77d   0/1     Completed   0          39s

> kubectl get jobs
NAME             COMPLETIONS   DURATION   AGE
hello-27804863   1/1           4s         2m47s
hello-27804864   1/1           5s         107s
hello-27804865   1/1           4s         47s

```

#### Task 4. Examine the logs of your Job's Pod

```
> kubectl get jobs
NAME             COMPLETIONS   DURATION   AGE
hello-27804889   1/1           4s         2m18s
hello-27804890   1/1           4s         78s
hello-27804891   1/1           5s         18s

> kubectl get pods --selector=job-name=hello-27804891
NAME                   READY   STATUS      RESTARTS   AGE
hello-27804891-q6dwp   0/1     Completed   0          83s

> kubectl logs hello-27804891-q6dwp
Sat Nov 12 22:51:02 UTC 2022
Welcome to the Kubernetes
```
