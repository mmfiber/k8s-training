#bin/bash

MANIFESTS_DIR='../../manifests/dev'

kubectl apply -f $MANIFESTS_DIR/deployment.yaml
