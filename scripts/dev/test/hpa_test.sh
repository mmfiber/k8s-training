#!/bin/bash

host='http://a287186daadc74cf28c26c5d1767075c-1950707856.ap-northeast-1.elb.amazonaws.com'
while sleep 0.01;
do
  curl "$host/test/high_cpu_usage";
done
