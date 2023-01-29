#!/bin/bash

export AWS_PROFILE=kops
export KOPS_STATE_STORE=s3://k8s-cluster-dev-masachoco-xyz-state-store

kops delete -f ../cluster.yaml --yes
