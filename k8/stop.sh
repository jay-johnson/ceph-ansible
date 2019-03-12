#!/bin/bash

app_files="rbd-storage-class.yaml rbd-provisioner.yaml rbd-volume-claim.yaml"
for f in ${app_files}; do
    echo "deleting app file: ${f}"
    kubectl delete --ignore-not-found -f ${f}
done

setup_files="rbd-secret-admin.yaml rbd-secret-kube.yaml rbd-cluster-role-binding.yaml rbd-cluster-role.yaml rbd-sa.yaml"

for f in ${setup_files}; do
    echo "deleting setup: ${f}"
    kubectl delete --ignore-not-found -f ${f}
done

