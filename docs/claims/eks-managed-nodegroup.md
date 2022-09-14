# Claim: EKSManagedNodeGroup

Use this Composite Resource Claim to provision a Managed Nodegroup for a pre-existing EKS cluster.

It will create:

- A cluster node IAM role
- A Managed Nodegroup

## Usage

1. Follow the [Getting Started](../../README.md#getting-started) docs.

1. Provision an EKS cluster using `kubectl apply -f <filename>`. Here's an [example configuration](../../claim-examples/eks-cluster-with-managed-nodegroup.yaml).
