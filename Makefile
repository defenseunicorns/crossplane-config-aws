KIND_VERSION := v0.14.0

KIND_BIN := kind
UNAME_S := $(shell uname -s)
UNAME_P := $(shell uname -p)
ifeq ($(UNAME_S), Linux)
	KIND_BIN := $(addsuffix -linux, $(KIND_BIN))
endif
ifeq ($(UNAME_S), Darwin)
	KIND_BIN := $(addsuffix -darwin, $(KIND_BIN))
endif
ifeq ($(UNAME_P), i386)
	KIND_BIN := $(addsuffix -amd64, $(KIND_BIN))
endif
ifeq ($(UNAME_P), x86_64)
	KIND_BIN := $(addsuffix -amd64, $(KIND_BIN))
endif
ifeq ($(UNAME_P), arm64)
	KIND_BIN := $(addsuffix -arm64, $(KIND_BIN))
endif

# Idiomatic way to force a target to always run, by having it depend on this dummy target
FORCE:

# Make all commands silent
.SILENT:

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show a list of all targets
	grep -E '^\S*:.*##.*$$' $(MAKEFILE_LIST) \
	| sed -n 's/^\(.*\): \(.*\)##\(.*\)/\1:\3/p' \
	| column -t -s ":"

clean:
	rm -rf build

build:
	mkdir -p build

build/kind: | build ## Download KinD to the build directory
	echo "Downloading KinD..."
	curl -sSL https://github.com/kubernetes-sigs/kind/releases/download/$(KIND_VERSION)/$(KIND_BIN) -o build/kind
	chmod +x build/kind

.PHONY: create-cluster
create-cluster: build/kind ## Create a k8s cluster
	echo "Creating the k8s cluster..."
	[[ "$(shell kind get clusters | grep test-crossplane-config-aws | wc -l | tr -d '[:space:]')" -eq "1" ]] || build/kind create cluster --name test-crossplane-config-aws

.PHONY: install-crossplane
install-crossplane: ## Install Crossplane to the currently configured k8s cluster
	echo "Installing Crossplane..."
	kubectl create namespace crossplane-system -o yaml --dry-run=client | kubectl apply -f -
	helm repo add crossplane-stable https://charts.crossplane.io/stable
	helm repo update
	helm upgrade --install crossplane --namespace crossplane-system crossplane-stable/crossplane
	echo "Waiting a bit for the CRDs to load..."
	sleep 30

.PHONY: install-crossplane-config-aws
install-crossplane-config-aws: ## Install the Crossplane configuration and your AWS credentials to the currently configured k8s cluster
	if [[ -z "${AWS_ACCESS_KEY_ID}" ]]; then echo "Must provide AWS_ACCESS_KEY_ID in environment" 1>&2; exit 1; fi
	if [[ -z "${AWS_SECRET_ACCESS_KEY}" ]]; then echo "Must provide AWS_SECRET_ACCESS_KEY in environment" 1>&2; exit 1; fi
	echo "Installing the Crossplane configuration..."
	[[ "$(shell kubectl get providerrevisions.pkg.crossplane.io --no-headers | wc -l | tr -d '[:space:]')" -eq "1" ]] || kubectl crossplane install provider crossplane/provider-aws:master
	echo "Waiting a bit for the CRDs to load..."
	sleep 60
	kubectl apply -f test/providerconfig.yaml
	kubectl apply -f src/claims --recursive
	echo "Applying your AWS creds..."
	kubectl create secret generic aws-creds -n crossplane-system --from-literal=creds="$$(echo "[default]\naws_access_key_id = ${AWS_ACCESS_KEY_ID}\naws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}")" -o yaml --dry-run=client | kubectl apply -f -

.PHONY: teardown-cluster
teardown-cluster: build/kind ## Tear down the k8s cluster
	echo "Tearing down the k8s cluster..."
	build/kind delete cluster --name test-crossplane-config-aws