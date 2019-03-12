#!/bin/bash

setup_files="rbd-secret-admin.yaml rbd-secret-kube.yaml rbd-cluster-role-binding.yaml rbd-cluster-role.yaml rbd-sa.yaml"

for f in ${setup_files}; do
    echo "applying setup: ${f}"
    kubectl apply -f ${f}
done

app_files="rbd-storage-class.yaml rbd-provisioner.yaml rbd-volume-claim.yaml"
for f in ${app_files}; do
    echo "applying app file: ${f}"
    kubectl apply -f ${f}
done
