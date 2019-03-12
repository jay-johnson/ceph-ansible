#!/bin/bash

pod_name=$(kubectl get po -n kube-system | grep rbd-prov| awk '{print $1}')
echo "kubectl logs -n kube-system -f ${pod_name}"
kubectl logs -n kube-system -f ${pod_name}
