#!/bin/bash

export AWS_PROFILE=kops

NAME='k8s.cluster.dev.masachoco.xyz'
MASTER_NODE_NAME="master-ap-northeast-1a.masters.$NAME"
RUNNING_CODE=16

masterNode=$(
  aws ec2 describe-instances --filter "Name=instance-state-name,Values=running" "Name=tag:Name,Values=$MASTER_NODE_NAME" \
  | jq '.Reservations[].Instances | .[0]' 
)
masterNodePublicIp=$(echo $masterNode | jq '.PublicIpAddress')
masterNodePrivateIp=$(echo $masterNode | jq '.PrivateIpAddress')

createChangeBatch() {
  cat << EOS
{
  "Comment": "UPSERT A record",
  "Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "$1",
      "Type": "A",
      "TTL": 300,
      "ResourceRecords": [{ "Value": $2}]
    }
  }]
}
EOS
}
API_RECORD_NAME="api.$NAME"
API_INTERNAL_RECORD_NAME="api.internal.$NAME"
KOPS_CTL_INTERNAL_RECORD_NAME="kops-controller.internal.$NAME"
HOSTED_ZONE_ID='Z019087915K70A9O5ZE9R'

changeBatch=$(createChangeBatch $API_RECORD_NAME $masterNodePublicIp)
aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch "$changeBatch"
changeBatch=$(createChangeBatch $API_INTERNAL_RECORD_NAME $masterNodePrivateIp)
aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch "$changeBatch"
changeBatch=$(createChangeBatch $KOPS_CTL_INTERNAL_RECORD_NAME $masterNodePrivateIp)
aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch "$changeBatch"
