# k8s-training

https://kops.sigs.k8s.io/

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
service 作れない iam 問題
```
no identity-based policy allows the elasticloadbalancing:ModifyLoadBalancerAttributes
```

tls サポート
https://kubernetes.io/ja/docs/concepts/services-networking/service/#publishing-services-service-types
