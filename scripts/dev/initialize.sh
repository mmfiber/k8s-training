#!/bin/bash

MANIFESTS_DIR='../../manifests/dev'

kubectl apply -f $MANIFESTS_DIR/namespace.yaml
kubectl apply -f $MANIFESTS_DIR/service.yaml
