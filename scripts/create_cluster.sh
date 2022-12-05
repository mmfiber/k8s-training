#bin/bash

export KOPS_STATE_STORE=s3://k8s-cluster-dev-masachoco-xyz-state-store 

kops create -f ../cluster.yaml
kops update cluster --name k8s.cluster.dev.masachoco.xyz --yes --admin
