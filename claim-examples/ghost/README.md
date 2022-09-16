# Connect Ghost to Crossplane Provisioned MySQL RDS

## Prerequisites

* EKS cluster provisioned
* VPC ID
* DB Subnet Group Name
* Workstation properties
    * EKS kubeconfig loaded
    * Crossplane CLI installed

## Install Crossplane in EKS

1. Create namespace
    ```bash
    kubectl create namespace crossplane-system
    ```

1. Install Crossplane
    ```bash
    helm upgrade -i crossplane --namespace crossplane-system crossplane-stable/crossplane
    ```

1. Install and Configure Crossplane AWS Provider
    ```bash
    
    kubectl crossplane install provider crossplane/provider-aws:master
    
    kubectl apply -f ../../test/providerconfig.yaml
    
    kubectl apply -R -f ../../src/claim-definitions/mysql-rds/

    AWS_PROFILE=default && echo -e "[default]\naws_access_key_id = $(aws configure get aws_access_key_id --profile $AWS_PROFILE)\naws_secret_access_key = $(aws configure get aws_secret_access_key --profile $AWS_PROFILE)" > creds.conf
    
    kubectl create secret generic aws-creds -n crossplane-system --from-file=creds=creds.conf
    
    rm creds.conf
    ```
1. Update RDS Configuratino with VPC ID and DB Subnet Group Name


1. Instantiate RDS Database and Security Group
    ```
    kubectl apply -f mysql-rds.yaml
    ```

1. Create Ghost Secet with MySQL Password
    ```
    kubectl create secret generic ghost-creds \
    --from-literal mysql-password=$(k get secret mysql-rds-test-composition -o jsonpath="{.data.password}" | base64 -d) \
    --from-literal ghost-password=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)
    ```

1. Deploy Ghost
    ```
    helm upgrade -i --namespace default my-release bitnami/ghost \
    --set service.type=LoadBalancer,existingSecret=ghost-creds,mysql.enabled=false,externalDatabase.host=mysql-rds-test-composition-8w68j-lmj6f.cm0mrgfonxcv.us-east-1.rds.amazonaws.com,externalDatabase.user=mysqladmin,externalDatabase.database=mysqlrdstest
    sleep 15
    helm upgrade -i --namespace default my-release bitnami/ghost \
    --set service.type=LoadBalancer,ghostHost=$(kubectl get svc --namespace default my-release-ghost --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}"),existingSecret=ghost-creds,mysql.enabled=false,externalDatabase.host=mysql-rds-test-composition-8w68j-lmj6f.cm0mrgfonxcv.us-east-1.rds.amazonaws.com,externalDatabase.user=mysqladmin,externalDatabase.database=mysqlrdstest
    ```