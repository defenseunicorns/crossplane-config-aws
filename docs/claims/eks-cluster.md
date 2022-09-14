# Claim: EKSCluster

Use this Composite Resource Claim to provision a production-ready EKS cluster given a pre-existing Enclave.

It will create:

- A Cluster IAM Role
- An EKS Cluster

## Usage

1. Follow the [Getting Started](../../README.md#getting-started) docs.

1. Provision an EKS cluster using `kubectl apply -f <filename>`. Here's an [example configuration](../../examples/eks-cluster.yaml).
