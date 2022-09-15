#!/bin/bash

sudo rm -rvf admin.conf
kubectl get secret -n crossplane-system kubeconfig-enclave-eks-db-flow-6lqg7 -o jsonpath="{.data.kubeconfig}" | base64 -d > admin.conf
chmod 0400 admin.conf

