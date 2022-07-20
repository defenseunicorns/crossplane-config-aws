# Contributing

## Testing

NOTE: The testing framework is still being designed/built. What is written below may not be ready for use.

### Prerequisites

- Docker running
- Using either MacOS or Linux
- Tools present in PATH:
  - Common tools like `grep`, `sed`, etc
  - `kubectl`
  - `helm`
- Env vars set:
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
- Crossplane CLI installed (`kubectl crossplane ...`)

### Usage

```shell
# Create a KinD cluster
make create-cluster
# Install Crossplane
make install-crossplane
# Install the crossplane-config-aws Config and your AWS credentials to the currently configured k8s cluster
make install-crossplane-config-aws
# Create an Enclave
kubectl apply -f examples/enclave.yaml
# DON'T FORGET TO DELETE YOU HAVE CREATED!!!
kubectl delete -f examples/enclave.yaml
# Tear down the cluster that got created
make teardown
```