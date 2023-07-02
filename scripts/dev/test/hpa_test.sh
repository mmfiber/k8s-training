#!/bin/bash

host='ae45d16010eb64921bc139377b6dd9eb-1767229850.ap-northeast-1.elb.amazonaws.com'
while sleep 0.01;
do
  curl "$host/test/high_cpu_usage";
done
