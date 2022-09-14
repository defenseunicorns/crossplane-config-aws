# Claim: Postgres RDS

Use this Composite Resource Claim to provision a Postgres SQL RDS in AWS. This claim provisions an Enclave and an EKS cluster which the Postgres instance will connect to.

It will create:

- Enclave for database
- EKS cluster which will connect with the database
- SecurityGroup for RDS database instance to allow ingress to database
- RDS instance that does not allow public connections
- Secret containing the necessary credentials for connecting with the database

## Usage

1. Follow the [Getting Started](../../README.md#getting-started) docs.

1. Provision an EKS cluster using `kubectl apply -f <filename>`. Here's an [example configuration](../../claim-examples/postgres-rds.yaml).