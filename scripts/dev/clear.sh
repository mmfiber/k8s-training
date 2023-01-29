#!/bin/bash

MANIFESTS_DIR='../../manifests/dev'

kubectl delete -f $MANIFESTS_DIR/hpa.yaml
kubectl delete -f $MANIFESTS_DIR/deployment.yaml
kubectl delete -f $MANIFESTS_DIR/service.yaml
kubectl delete -f $MANIFESTS_DIR/namespace.yaml
