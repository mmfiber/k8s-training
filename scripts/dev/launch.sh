#!/bin/bash

MANIFESTS_DIR='../../manifests/dev'

kubectl apply -f $MANIFESTS_DIR/pod.yaml
kubectl apply -f $MANIFESTS_DIR/deployment.yaml
kubectl apply -f $MANIFESTS_DIR/hpa.yaml
kubectl apply -f $MANIFESTS_DIR/service.yaml
kubectl apply -f $MANIFESTS_DIR/cluster-autoscaler-autodiscover.yaml
