#!/bin/bash

sudo rm -rvf admin.conf
SECRET=$(kubectl get secret -A -o name | grep ^secret/kubeconfig)
kubectl get $SECRET -n crossplane-system -o jsonpath="{.data.kubeconfig}" | base64 -d > admin.conf
chmod 0400 admin.conf

