RDS

- provision postgres RDS

Run the following commands from the top level of this repository in order to run crossplane on a `kind` cluster locally using the Makefile:

1. `make build/kind`
2. `make create-cluster`
3. `make install-crossplane`
4. Wait until crossplane finishes its install by running `k get pkg -A`
5. Ensure that your correct AWS profile is set.
6. `kubectl create secret generic aws-creds -n crossplane-system --from-file=creds=./creds.conf`
6. `make install-crossplane-config-aws`

Note: The Makefile utilizes the providerconfig.yaml file in the test directory.

7. Apply the following directory to the cluster:
    - `k apply -f ./src/claims/postgres-rds/.`

8. Apply the postgres example file to create a postgres RDS.