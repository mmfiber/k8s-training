```sh
aws cloudformation create-stack \
 --stack-name k8s-training-sample-app \
 --template-body file://$(pwd)/cfn/ecr.yaml
```