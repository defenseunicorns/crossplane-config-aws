# crossplane-config-aws
Crossplane configuration that provides various Composite Resource Claims that make it easier to provision production-level infrastructure in AWS

## Claims

- [Enclave](docs/claims/enclave.md) - Provision a production-ready Virtual Private Cloud (VPC) in AWS with all the trimmings.

## Getting Started

1. Run a Kubernetes cluster, install crossplane, and install the Crossplane CLI using the instructions [here](https://crossplane.io/docs/v1.9/getting-started/install-configure.html). Don't use the `getting-started-with-aws` configuration.

1. Install this configuration. Use the [packages](https://github.com/defenseunicorns/crossplane-config-aws/pkgs/container/crossplane-config-aws) page to find the latest version.

    ```shell
    kubectl crossplane install configuration ghcr.io/defenseunicorns/crossplane-config-aws:<version>
    ```

1. Apply your AWS credentials using the instructions [here](https://crossplane.io/docs/v1.9/getting-started/install-configure.html#get-aws-account-keyfile) under the sections "Get AWS Account Keyfile", "Create a Provider Secret", and "Configure the Provider"

1. Provision your infrastructure using the [Claims](docs/claims) that are offered by this configuration.