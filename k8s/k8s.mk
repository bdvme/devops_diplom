.PHONY: all

CLUSTER_ID ?= $(shell yc managed-kubernetes cluster list --format json | jq -r '.[0].id')
SA_TOKEN ?= $(shell kubectl -n kube-system get secret $(shell kubectl -n kube-system get secret | \
  		grep admin-user-token | awk '{print $$1}') -o json | jq -r .data.token | base64 --d)
MASTER_ENDPOINT_INT ?= $(shell yc managed-kubernetes cluster get --id $(CLUSTER_ID) \
  		--format json | jq -r .master.endpoints.internal_v4_endpoint)
MASTER_ENDPOINT_EXT ?= $(shell yc managed-kubernetes cluster get --id $(CLUSTER_ID) \
  		--format json | jq -r .master.endpoints.external_v4_endpoint)

WORKSPACE = stage

WORKSPACE_PATH = ./$(WORKSPACE)

all: get_credential create_ca_pem create_service_acc create_kubeconf_int create_kubeconf_ext use-context_ext

get_credential:
	yc managed-kubernetes cluster \
  		get-credentials $(CLUSTER_ID)\
  		--external --force

create_ca_pem:
	yc managed-kubernetes cluster get --id $(CLUSTER_ID) --format json | \
  		jq -r .master.master_auth.cluster_ca_certificate | \
  		awk '{gsub(/\\n/,"\n")}1' > $(WORKSPACE_PATH)/ca.pem

create_service_acc:
	kubectl delete -f sa.yml --ignore-not-found=true
	kubectl create -f sa.yml --allow-missing-template-keys=true

create_kubeconf_int:
	
	kubectl config set-cluster k8s \
		--certificate-authority=$(WORKSPACE_PATH)/ca.pem \
  		--server=$(MASTER_ENDPOINT_INT) \
  		--kubeconfig=$(WORKSPACE_PATH)/kubeconfig-int
	kubectl config set-credentials admin-user \
  		--token=$(SA_TOKEN) \
  		--kubeconfig=$(WORKSPACE_PATH)/kubeconfig-int
	kubectl config set-context default \
  		--cluster=k8s \
  		--user=admin-user \
  		--kubeconfig=$(WORKSPACE_PATH)/kubeconfig-int

create_kubeconf_ext:
	kubectl config set-cluster k8s \
		--certificate-authority=$(WORKSPACE_PATH)/ca.pem \
  		--server=$(MASTER_ENDPOINT_EXT) \
  		--kubeconfig=$(WORKSPACE_PATH)/kubeconfig-ext
	kubectl config set-credentials admin-user \
  		--token=$(SA_TOKEN) \
  		--kubeconfig=$(WORKSPACE_PATH)/kubeconfig-ext
	kubectl config set-context default \
  		--cluster=k8s \
  		--user=admin-user \
  		--kubeconfig=$(WORKSPACE_PATH)/kubeconfig-ext


use-context_ext:
	kubectl config use-context default \
  		--kubeconfig=$(WORKSPACE_PATH)/kubeconfig-ext
