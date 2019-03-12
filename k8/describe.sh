#!/bin/bash

kubectl describe -n kube-system po $(kubectl get po -n kube-system | grep rbd-prov | awk '{print $1}')
