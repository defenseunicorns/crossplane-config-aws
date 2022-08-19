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
# DON'T FORGET TO DELETE WHAT YOU HAVE CREATED!!!
kubectl delete -f examples/enclave.yaml
# Tear down the cluster that got created
make teardown
```

### Code Quality

* All managed resources that need a name specified need a unique name. All managed resources in Compositions that support tags need a `Name` tag. Here's the recommended way to do it for resources that use an array for the tags field. It's long and not very DRY, so we should be on the lookout for a better way to do it as we learn.

  ```yaml
  ...
  base:
    spec:
      forProvider:
        tags:
          - key: Name
  patches:
    - type: CombineFromComposite
      combine:
        variables:
          - fromFieldPath: metadata.name                   ## "metadata.name" always contains a small UID that is assigned by Crossplane
        strategy: string
        string:
          fmt: "%s-<resource-name>"
      toFieldPath: spec.forProvider.tags[0].value
      policy:
        fromFieldPath: Required
  ```
* All managed resources in Compositions need the label `internalName` with a value that is unique within the Composition.
* All `*Selector:` fields in Compositions need `matchControllerRef: true` unless the user is meant to select a resource that is part of a different Composite Resource Claim.
* All apiVersions of XRDs and Compositions need a base of `infra.bigbang.dev` and need to use k8s-style versioning (`v1alpha1`, `v1beta1`, `v1`, etc)