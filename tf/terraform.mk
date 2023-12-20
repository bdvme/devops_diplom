# Makefile для автоматизации сборки 
.PHONY: all init plan apply destroy refresh

TF_DEFAULT = default
TF_PROD  = prod
TF_STAGE = stage
TF_PATH_KEY = ./key
TF_PATH = ./

BACKEND_ACCESS_KEY ?= $(shell cat $(TF_PATH_KEY)/$(WORKSPACE)/sa-key.json | jq -r .access_key.key_id)
BACKEND_SECRET_KEY ?= $(shell cat $(TF_PATH_KEY)/$(WORKSPACE)/sa-key.json | jq -r .secret)

export TF_CLI_CONFIG_FILE=./.terraformrc

include ../.env

all: init workspace_new workspace_select plan apply
#plan

upgrade:
	terraform init -upgrade
init:
	@echo $(WORKSPACE)
	@echo terraform init -reconfigure -backend-config="bucket=$(yandex_s3_bucket)" -backend-config="access_key" -backend-config="secret_key"
	@terraform init -reconfigure -backend-config="bucket=$(yandex_s3_bucket)" -backend-config="access_key=$(BACKEND_ACCESS_KEY)" -backend-config="secret_key=$(BACKEND_SECRET_KEY)"
	terraform providers lock -net-mirror=https://terraform-mirror.yandexcloud.net -platform=darwin_arm64 yandex-cloud/yandex
	

workspace_new:
#	terraform workspace select $(TF_DEFAULT)
ifneq ($(shell terraform workspace list | awk '/prod/{print $$1}'), $(TF_PROD))
ifneq ('$(shell terraform workspace list | awk '/prod/{print $$1}')', '*')
	terraform workspace new $(TF_PROD)
endif
endif

ifneq ($(shell terraform workspace list | awk '/stage/{print $$1}'), $(TF_STAGE))
ifneq ('$(shell terraform workspace list | awk '/stage/{print $$1}')', '*')
	terraform workspace new $(TF_STAGE)
endif
endif
workspace_select:
	terraform workspace select $(WORKSPACE)
plan:
	terraform plan -var-file="$(TF_PATH).tfvars" -var "yandex_folder_id=$(YC_FOLDER_ID)"

apply:
	terraform apply -auto-approve -var-file="$(TF_PATH).tfvars" -var "yandex_folder_id=$(YC_FOLDER_ID)"

destroy:
	terraform destroy -auto-approve -var-file="$(TF_PATH).tfvars" -var "yandex_folder_id=$(YC_FOLDER_ID)" || true

refresh:
	terraform get -update
	@echo terraform init -reconfigure -backend-config="bucket" -backend-config="access_key" -backend-config="secret_key"
	@terraform init -reconfigure -backend-config="bucket=$(yandex_s3_bucket)" -backend-config="access_key=$(BACKEND_ACCESS_KEY)" -backend-config="secret_key=$(BACKEND_SECRET_KEY)"
	terraform refresh -var-file="$(TF_PATH).tfvars" -var "yandex_folder_id=$(YC_FOLDER_ID)"
