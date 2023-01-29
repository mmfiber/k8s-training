# k8s-training

https://kops.sigs.k8s.io/
https://kubernetes.io/ja/docs/setup/production-environment/tools/kops/
https://kops.sigs.k8s.io/cluster_spec/

```sh
~/Documents/Github/k8s-training 
❯ export KOPS_STATE_STORE=s3://k8s-cluster-dev-masachoco-xyz-state-store/k8s.cluster.dev.masachoco.xyz

~/Documents/Github/k8s-training 
❯ kops create -f cluster.yaml

Created cluster/k8s.cluster.dev.masachoco.xyz
Created instancegroup/master-ap-northeast-1a
Created instancegroup/nodes-ap-northeast-1a

To deploy these resources, run: kops update cluster --name k8s.cluster.dev.masachoco.xyz --yes


~/Documents/Github/k8s-training 
❯ kops update cluster --name k8s.cluster.dev.masachoco.xyz --yes --admin
```

```sh
~/Documents/Github/k8s-training 
❯ export KOPS_STATE_STORE=s3://k8s-cluster-dev-masachoco-xyz-state-store/k8s.cluster.dev.masachoco.xyz

~/Documents/Github/k8s-training 
❯ kops delete -f cluster.yaml --yes
```

### coredns のインストール
常に入れとくべきらしい
https://kubernetes.io/ja/docs/concepts/services-networking/service/#service%E3%81%AE%E5%AE%9A%E7%BE%A9
https://github.com/coredns/helm
```sh
helm repo add coredns https://coredns.github.io/helm
helm --namespace=kube-system install coredns coredns/coredns
```

### ingress
service が pod を外部に ip に依存せずに公開するものだとしたら、ingress はプロキシ的なもの。
service の前段に配置されるイメージ。
https://kubernetes.io/ja/docs/concepts/services-networking/ingress-controllers/
https://github.com/kubernetes-sigs/aws-load-balancer-controller#readme

### high availability
３つのAZが推奨
https://kops.sigs.k8s.io/operations/high_availability/

次回
route53 に正しくIPが振られない
-> shell でとりあえず解決

pod 起動しない
```
❯ kubectl describe po sample-deployment-76969cc87-blrrn -n dev
Name:           sample-deployment-76969cc87-blrrn
Namespace:      dev
Priority:       0
Node:           i-0ccba69bfd238af9e/172.20.44.205
Start Time:     Mon, 09 Jan 2023 14:44:51 +0900
Labels:         app=sample-app
                pod-template-hash=76969cc87
Annotations:    <none>
Status:         Pending
IP:             
IPs:            <none>
Controlled By:  ReplicaSet/sample-deployment-76969cc87
Containers:
  sample-app:
    Container ID:   
    Image:          834894006862.dkr.ecr.ap-northeast-1.amazonaws.com/k8s-sample-app:latest
    Image ID:       
    Port:           <none>
    Host Port:      <none>
    State:          Waiting
      Reason:       ContainerCreating
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-ps2f5 (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  kube-api-access-ps2f5:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  9s    default-scheduler  Successfully assigned dev/sample-deployment-76969cc87-blrrn to i-0ccba69bfd238af9e
  Normal  Pulling    9s    kubelet            Pulling image "834894006862.dkr.ecr.ap-northeast-1.amazonaws.com/k8s-sample-app:latest"
  Normal  Pulled     1s    kubelet            Successfully pulled image "834894006862.dkr.ecr.ap-northeast-1.amazonaws.com/k8s-sample-app:latest" in 8.002563936s
  Normal  Created    0s    kubelet            Created container sample-app
  Normal  Started    0s    kubelet            Started container sample-app

❯ kubectl logs sample-deployment-76969cc87-blrrn 
Error from server (NotFound): pods "sample-deployment-76969cc87-blrrn" not found
```
-> master の インスタンスタイプをケッチて t2.micro にしてたら、雑魚すぎてリソース足りず、kube-system の pod がいくつか pending なってた。
t3.medium で解決。

service 作れない iam 問題
```
no identity-based policy allows the elasticloadbalancing:ModifyLoadBalancerAttributes

Error syncing load balancer: failed to ensure load balancer: Unable to update load balancer attributes during attribute sync: "AccessDenied: User: arn:aws:sts::834894006862:assumed-role/aws-cloud-controller-manager.kube-system.sa.k8s.cluster.d-5miqv5/1673534049542276681 is not authorized to perform: elasticloadbalancing:ModifyLoadBalancerAttributes on resource: arn:aws:elasticloadbalancing:ap-northeast-1:834894006862:loadbalancer/aa77852ec14b348318cf670c6c5fd3d6 because no identity-based policy allows the elasticloadbalancing:ModifyLoadBalancerAttributes action\n\tstatus code: 403, request id: 2ce56a73-7854-40bb-bf66-0448de37f54b"
```
-> 時間経つといけた、なぞい
```
Events:
  Type     Reason                  Age                   From                Message
  ----     ------                  ----                  ----                -------
  Warning  SyncLoadBalancerFailed  6m2s                  service-controller  Error syncing load balancer: failed to ensure load balancer: Unable to update load balancer attributes during attribute sync: "AccessDenied: User: arn:aws:sts::834894006862:assumed-role/aws-cloud-controller-manager.kube-system.sa.k8s.cluster.d-5miqv5/1673874585129551539 is not authorized to perform: elasticloadbalancing:ModifyLoadBalancerAttributes on resource: arn:aws:elasticloadbalancing:ap-northeast-1:834894006862:loadbalancer/a10ea2678c73644be94e2987bdd63a55 because no identity-based policy allows the elasticloadbalancing:ModifyLoadBalancerAttributes action\n\tstatus code: 403, request id: 85fdc2d0-0bf5-48c2-98aa-e23a1653a365"
  Warning  SyncLoadBalancerFailed  5m56s                 service-controller  Error syncing load balancer: failed to ensure load balancer: Unable to update load balancer attributes during attribute sync: "AccessDenied: User: arn:aws:sts::834894006862:assumed-role/aws-cloud-controller-manager.kube-system.sa.k8s.cluster.d-5miqv5/1673874585129551539 is not authorized to perform: elasticloadbalancing:ModifyLoadBalancerAttributes on resource: arn:aws:elasticloadbalancing:ap-northeast-1:834894006862:loadbalancer/a10ea2678c73644be94e2987bdd63a55 because no identity-based policy allows the elasticloadbalancing:ModifyLoadBalancerAttributes action\n\tstatus code: 403, request id: 57245664-df87-4a28-91ab-af463f478744"
  Warning  SyncLoadBalancerFailed  5m45s                 service-controller  Error syncing load balancer: failed to ensure load balancer: Unable to update load balancer attributes during attribute sync: "AccessDenied: User: arn:aws:sts::834894006862:assumed-role/aws-cloud-controller-manager.kube-system.sa.k8s.cluster.d-5miqv5/1673874585129551539 is not authorized to perform: elasticloadbalancing:ModifyLoadBalancerAttributes on resource: arn:aws:elasticloadbalancing:ap-northeast-1:834894006862:loadbalancer/a10ea2678c73644be94e2987bdd63a55 because no identity-based policy allows the elasticloadbalancing:ModifyLoadBalancerAttributes action\n\tstatus code: 403, request id: 97dd9cfa-2d57-4bc1-ab0f-9b3e44f48952"
  Warning  SyncLoadBalancerFailed  5m25s                 service-controller  Error syncing load balancer: failed to ensure load balancer: Unable to update load balancer attributes during attribute sync: "AccessDenied: User: arn:aws:sts::834894006862:assumed-role/aws-cloud-controller-manager.kube-system.sa.k8s.cluster.d-5miqv5/1673874585129551539 is not authorized to perform: elasticloadbalancing:ModifyLoadBalancerAttributes on resource: arn:aws:elasticloadbalancing:ap-northeast-1:834894006862:loadbalancer/a10ea2678c73644be94e2987bdd63a55 because no identity-based policy allows the elasticloadbalancing:ModifyLoadBalancerAttributes action\n\tstatus code: 403, request id: f25aaa67-50cb-4eb6-96b3-8e9d2d8bdaff"
  Warning  SyncLoadBalancerFailed  4m44s                 service-controller  Error syncing load balancer: failed to ensure load balancer: Unable to update load balancer attributes during attribute sync: "AccessDenied: User: arn:aws:sts::834894006862:assumed-role/aws-cloud-controller-manager.kube-system.sa.k8s.cluster.d-5miqv5/1673874585129551539 is not authorized to perform: elasticloadbalancing:ModifyLoadBalancerAttributes on resource: arn:aws:elasticloadbalancing:ap-northeast-1:834894006862:loadbalancer/a10ea2678c73644be94e2987bdd63a55 because no identity-based policy allows the elasticloadbalancing:ModifyLoadBalancerAttributes action\n\tstatus code: 403, request id: 6af8ff29-290b-4a6d-a016-7bed0c316a5b"
  Normal   EnsuringLoadBalancer    3m24s (x6 over 6m6s)  service-controller  Ensuring load balancer
  Normal   EnsuredLoadBalancer     3m23s                 service-controller  Ensured load balancer
```
[同じ問題抱えている人いる](https://github.com/kubernetes/kops/issues/12671#issuecomment-974280748)

service が外部に公開されない
https://kops.sigs.k8s.io/addons/
classic load balance の scheme が internal になっている
https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-internal-load-balancers.html?icmpid=docs_elb_console
-> annotation で internal にしてるだけだった、、、

hpa
  * [自動的に設定されている](https://kops.sigs.k8s.io/horizontal_pod_autoscaling/)
    cluster の .spec に以下を設定
    ```yaml
    spec:
      certManager:
        enabled: true
      metricsServer:
        enabled: true
        insecure: false
    ```
    [cert-manager の有効化が必要](https://github.com/kubernetes/kops/blob/master/docs/addons.md#metrics-server)
  * [metrics](https://kops.sigs.k8s.io/horizontal_pod_autoscaling/#support-for-multiple-metrics)

cluster へのアクセスを load balance internal にしてみる
keel やってる。そもそもなんで必要かから考える。

tls サポート
https://kubernetes.io/ja/docs/concepts/services-networking/service/#publishing-services-service-types
