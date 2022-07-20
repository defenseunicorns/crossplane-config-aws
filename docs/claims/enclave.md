# Claim: Enclave

Use this Composite Resource Claim to provision a production-ready Virtual Private Cloud (VPC) in AWS with all the trimmings.

It will create:

- A VPC
- 3 public subnets
- 3 private subnets
- A DBSubnetGroup consisting of the 3 private subnets
- An Internet Gateway
- An Elastic IP Address (for the NAT Gateway)
- A NAT Gateway that the private subnets use for internet egress
- A Route Table for the public subnets that allows incoming traffic using the Internet Gateway
- 3 Route Tables (one for each private subnet) that allow outgoing internet traffic using the NAT Gateway while barring incoming internet traffic

## Usage

1. Follow the [Getting Started](../../README.md#getting-started) docs.

1. Provision an enclave using `kubectl apply -f <filename>`. Here's an example configuration:

    ```yaml
    apiVersion: infra.bigbang.dev/v1alpha1
    kind: Enclave
    metadata:
      name: my-enclave
      namespace: default
    spec:
      parameters:
        resourceName: my-enclave
        region: us-east-1
        availabilityZone1: us-east-1a
        availabilityZone2: us-east-1b
        availabilityZone3: us-east-1c
      compositionSelector:
        matchLabels:
          provider: aws
    ```