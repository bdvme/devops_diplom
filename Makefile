# Makefile для автоматизации сборки 
.PHONY: all yc ssh_key_create terraform tf_apply tf_destroy k8s ansible clean

YC_PROFILE = $(shell yc config profile list | awk '/$(yandex_profile)/{print $$1}')
YC_SERVICE_ACC ?= $(shell yc iam service-account list --folder-name=$(WORKSPACE) | awk '/$(yandex_service_acc)/{print $$4}')
YC_SERVICE_ACC_ADM ?= $(shell yc iam service-account list --folder-name=$(WORKSPACE) | awk '/$(yandex_service_admin_acc)/{print $$4}')
YC_STORAGE_BUCKET ?= $(shell yc storage bucket list --folder-name=$(WORKSPACE_BACKET) | awk '/$(yandex_s3_bucket)/{print $$2}')
YC_FOLDER_ID ?= $(shell yc resource-manager folder get $(WORKSPACE) --format=json | jq -r .id)
YC_SERVICE_ACC_ID ?= $(shell yc iam service-account get $(WORKSPACE)-$(yandex_service_acc) --folder-name=$(WORKSPACE) --format=json | jq -r .id)
YC_SERVICE_ACC_ADM_ID ?= $(shell yc iam service-account get $(WORKSPACE)-$(yandex_service_admin_acc) --folder-name=$(WORKSPACE) --format=json | jq -r .id)
# Путь до папки c Ansible
ANSIBLE_PATH = ./ansible
# Путь до папки c Terraform
TF_PATH = ./tf
# Путь до папки c ключами доступа к Yandex.Cloud
TF_PATH_KEY = ./tf/key
# Путь до папки c демо приложением
APP_PATH = ./app/demo-project
# Путь до папки c Terraform для размещения в репозитории
TF-INFRA_PATH = ./tf-infra
# Путь до папки c настройками для k8s
K8S_PATH = ./k8s
# Путь до папки c SSH-ключами 
SSH_PATH = ./ssh_key
# Путь до папки c манифестом для деплоя Atlantis
ATLANTIS_PATH = $(K8S_PATH)/atlantis
# Рабочее пространство по умолчанию, а так же
# папка в Yandex.Cloud для размещения инфраструктуры "stage"
WORKSPACE = stage
# Папка в Yandex.Cloud для размещения бэкенда
WORKSPACE_BACKET = backet
# API token для работы с REST API GitLab
API_TOKEN = api_token

#Makefile для автоматизации сборки
ANSIBLE_MK = ansible.mk
TF_MK = terraform.mk
K8S_MK = k8s.mk

# Добавляем в сборку переменные окружения из файла .env
# Структура файла:
# yandex_token=y0_AgAAAAA********************
# yandex_zone=ru-central1-a
# yandex_cloud_id=b1g*************
# yandex_service_acc=service-acc01
# yandex_service_admin_acc=service-admin-acc01
# yandex_profile=profile01
# yandex_s3_bucket=backend01

include .env

all:
# Выполняем предварительные настройки Yandex.Cloud для рабочего пространства stage
	$(MAKE) yc_prepare WORKSPACE=stage
# Выполняем предварительные настройки Yandex.Cloud для рабочего пространства prod
	$(MAKE) yc_prepare WORKSPACE=prod
# Передаем на выполнение создание инфраструктуры для рабочего пространства stage
	$(MAKE) terraform WORKSPACE=$(WORKSPACE)
# Передаем на выполнение создание инфраструктуры для рабочего пространства 
# stage без применения
#	$(MAKE) terraform-dry WORKSPACE=$(WORKSPACE)
# Передаем на выполнение применение плейбука ansible для рабочего 
# пространства stage
	$(MAKE) ansible WORKSPACE=$(WORKSPACE)

# Задание для предварительных настроек Yandex.Cloud
yc_prepare: yc ssh_key_create

# Задание для предварительных настроек Yandex.Cloud
yc: yc_create_folder yc_set_profile yc_service_acc yc_service_adm_acc yc_create_s3 yc_make_key

# Задание для создания SSH-ключей для инстансов в каждом рабочем пространстве
ssh_key_create:
	mkdir -p $(SSH_PATH)
	mkdir -p $(SSH_PATH)/$(WORKSPACE)
	ssh-keygen -t rsa -q -f "$(SSH_PATH)/$(WORKSPACE)/id_rsa_vm" -N ""
	ssh-keygen -t rsa -q -f "$(SSH_PATH)/$(WORKSPACE)/id_rsa_vm-bastion" -N ""
	ssh-keygen -t rsa -q -f "$(SSH_PATH)/$(WORKSPACE)/id_rsa_k8s" -N ""

# Задание для создания папок prod, stage, backet в Yandex.Cloud
yc_create_folder:
ifneq ($(shell yc resource-manager folder list --format=json | jq -r '.[] | select(.name=="$(WORKSPACE)")' | jq -r '.name'), $(WORKSPACE))
	yc resource-manager folder create --name $(WORKSPACE)
endif

ifneq ($(shell yc resource-manager folder list --format=json | jq -r '.[] | select(.name=="$(WORKSPACE_BACKET)")' | jq -r '.name'), $(WORKSPACE_BACKET))
	yc resource-manager folder create --name $(WORKSPACE_BACKET)
endif

# Задание для конфигурирования профайла и его активации
yc_set_profile:
ifneq ($(YC_PROFILE), $(yandex_profile))
	@echo yc config profile create 
	@yc config profile create $(yandex_profile)
endif
	@echo yc config set folder-id
	@yc config set folder-id $(YC_FOLDER_ID)
	
	@echo yc config set cloud-id
	@yc config set cloud-id $(yandex_cloud_id)
	
	@echo yc config set token
	@yc config set token $(yandex_token)
	@echo yc config set compute-default-zone
	@yc config set compute-default-zone $(yandex_zone)	
# Создается сервисный аккаунт $(yandex_service_acc)
ifneq ($(shell yc iam service-account list --folder-name=$(WORKSPACE) --format=json | jq -r '.[] | select(.name=="$(WORKSPACE)-$(yandex_service_acc)")' | jq -r '.name'), $(WORKSPACE)-$(yandex_service_acc))
	yc iam service-account create --folder-name=$(WORKSPACE) --name $(WORKSPACE)-$(yandex_service_acc)
endif
# Создается сервисный аккаунт $(yandex_service_admin_acc)
ifneq ($(shell yc iam service-account list --folder-name=$(WORKSPACE) --format=json | jq -r '.[] | select(.name=="$(WORKSPACE)-$(yandex_service_admin_acc)")' | jq -r '.name'), $(WORKSPACE)-$(yandex_service_admin_acc))
	yc iam service-account create --folder-name=$(WORKSPACE) --name $(WORKSPACE)-$(yandex_service_admin_acc)
endif
	@echo yc config profile activate
	@yc config profile activate $(yandex_profile)

# Задание для добавления роли editor и доступа к папкам $(YC_FOLDER_ID), 
# $(WORKSPACE_BACKET) для сервисного аккаунта $(yandex_service_acc)
yc_service_acc:
	yc resource-manager folder add-access-binding $(YC_FOLDER_ID) --role editor --subject serviceAccount:$(YC_SERVICE_ACC_ID)
	yc resource-manager folder add-access-binding $(WORKSPACE_BACKET) --role editor --subject serviceAccount:$(YC_SERVICE_ACC_ID)
# Задание для добавления роли editor и доступа к папкам $(YC_FOLDER_ID) 
# для сервисного аккаунта $(yandex_service_admin_acc)
yc_service_adm_acc:
	yc resource-manager folder add-access-binding $(YC_FOLDER_ID) --role admin --subject serviceAccount:$(YC_SERVICE_ACC_ADM_ID)
# Задание для создания бакета для бэкенда
yc_create_s3:
ifneq ($(YC_STORAGE_BUCKET), $(yandex_s3_bucket))
	yc storage bucket create --folder-name=$(WORKSPACE_BACKET) --name $(yandex_s3_bucket)
endif
#Задание для создания ключей доступа сервисных аккаунтов	
yc_make_key:
	mkdir -p $(TF_PATH_KEY)
	mkdir -p $(TF_PATH_KEY)/$(WORKSPACE)
	mkdir -p $(TF-INFRA_PATH)
	mkdir -p $(ATLANTIS_PATH)
	mkdir -p $(ATLANTIS_PATH)/$(WORKSPACE)
	yc iam key create --service-account-name $(WORKSPACE)-$(yandex_service_admin_acc) --folder-name=$(WORKSPACE) --output $(TF_PATH_KEY)/$(WORKSPACE)/key_admin.json
	yc iam key create --service-account-name $(WORKSPACE)-$(yandex_service_acc) --folder-name=$(WORKSPACE) --output $(TF_PATH_KEY)/$(WORKSPACE)/key_editor.json
	yc iam access-key create --service-account-name $(WORKSPACE)-$(yandex_service_acc) --folder-name=$(WORKSPACE) --format json > $(TF_PATH_KEY)/$(WORKSPACE)/sa-key.json
	yc config set service-account-key $(TF_PATH_KEY)/$(WORKSPACE)/key_admin.json
	@echo yc config set token
	@yc config set token $(yandex_token)
#Задание для создания ключа доступа сервисного аккаунта для K8s
yc_key_registry:
	mkdir -p $(K8S_PATH)/$(WORKSPACE)
	yc iam key create --service-account-name $(WORKSPACE)-sa-k8s --folder-name=$(WORKSPACE) -o $(K8S_PATH)/$(WORKSPACE)/key.json

# Задание для выполнения создания инфраструктуры для рабочего пространства 
# без применения
terraform-dry:	tf_init tf_workspace tf_plan
# Задание для выполнения создания инфраструктуры для рабочего пространства
terraform: tf_init tf_workspace tf_plan tf_apply yc_key_registry

# Задание для выполнения создания инфраструктуры для рабочего пространства 
# и применения плейбука ansible
tf_ansible: tf_plan tf_apply yc_key_registry ansible

# Задание для выполнения удаления, создания инфраструктуры для рабочего 
# пространства и применения плейбука ansible
tf_destroy_ansible: tf_destroy tf_plan tf_apply yc_key_registry ansible

debug:
	@echo $(yandex_profile)
	@echo $(yandex_token)

# Передаем на выполнение команду Terraform upgrade
tf_upgrade:
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) upgrade
# Передаем на выполнение команду Terraform init для текущего рабочего 
# пространства
tf_init:
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) init WORKSPACE=$(WORKSPACE)
# Задание для выполнения создания нового рабочего пространства и 
# его последующий выбор
tf_workspace: tf_workspace_new tf_workspace_select
# Передаем на выполнение создание нового рабочего пространства из 
# переменной WORKSPACE
tf_workspace_new:
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) workspace_new WORKSPACE=$(WORKSPACE)
# Передаем на выполнение команду выбора рабочего пространства из 
# переменной WORKSPACE
tf_workspace_select:
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) workspace_select WORKSPACE=$(WORKSPACE)
# Передаем на выполнение команду Terraform plan для текущего рабочего 
# пространства в папке с ID $(YC_FOLDER_ID)
tf_plan:
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) plan YC_FOLDER_ID=$(YC_FOLDER_ID)
# Передаем на выполнение команду Terraform apply для текущего рабочего 
# пространства в папке с ID $(YC_FOLDER_ID)
tf_apply:
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) apply YC_FOLDER_ID=$(YC_FOLDER_ID)
# Задание для выполнения удаления инфраструктуры рабочего пространства 
# в папке с ID $(YC_FOLDER_ID)
tf_destroy:
	$(MAKE) tf_workspace_select
	$(MAKE) k8s_delete_app
	$(MAKE) yc_delete_image 
	$(MAKE) yc_delete_registry
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) destroy YC_FOLDER_ID=$(YC_FOLDER_ID)
	
# Передаем на выполнение команду Terraform refresh
tf_refresh:
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) refresh WORKSPACE=$(WORKSPACE) YC_FOLDER_ID=$(YC_FOLDER_ID)
# Передаем на выполнение команду для выполнения основного плейбука 
# Ansible для рабочего пространства из переменной WORKSPACE
ansible:
	$(MAKE) -C $(ANSIBLE_PATH) -f $(ANSIBLE_MK) apply WORKSPACE=$(WORKSPACE)
# Передаем на выполнение команду для выполнения плейбука Ansible 
# для настройки GitLab для рабочего пространства из переменной WORKSPACE 
# с использованием API_TOKEN 
gitlab_set_settings:
	$(MAKE) -C $(ANSIBLE_PATH) -f $(ANSIBLE_MK) gitlab_set_settings WORKSPACE=$(WORKSPACE) API_TOKEN=$(API_TOKEN)
# Задание для выполнения удаления образов из реестра контейнеров
yc_delete_image:
	$(shell yc container image list --folder-name=$(WORKSPACE) --format=json | jq -r .[].id | while read id ; do yc container image delete $$id --folder-name=$(WORKSPACE); done)
# Задание для выполнения удаления реестра контейнеров
yc_delete_registry:
	$(shell yc container registry list --folder-name=$(WORKSPACE) --format=json | jq -r .[].id | while read id ; do yc container registry delete $$id --folder-name=$(WORKSPACE); done)
# Задание для выполнения удаления приложений из кластера
k8s_delete_app:
	$(MAKE) -C $(ANSIBLE_PATH) -f $(ANSIBLE_MK) k8s_delete_app WORKSPACE=$(WORKSPACE)
# Передаем на выполнение команду выполнения плейбука Ansible для подготовки системы мониторинга
monitoring:
	$(MAKE) -C $(ANSIBLE_PATH) -f $(ANSIBLE_MK) monitoring WORKSPACE=$(WORKSPACE)
# Передаем на выполнение команды последовательного удаления созданой инфраструктуры инфраструктуры
clean:
	$(MAKE) tf_destroy WORKSPACE=stage
	$(MAKE) tf_destroy WORKSPACE=prod
	$(MAKE) del WORKSPACE=stage
	$(MAKE) del WORKSPACE=prod
	$(MAKE) purge

# Задание для выполнения удаления созданой инфраструктуры дефолтного рабочего 
# пространства, или переданного через переменную WORKSPACE
clean_wspc: tf_destroy del

# Задача для удаления каталогов и сервисных аккаунтов дефолтного рабочего 
# пространства, или переданного через переменную WORKSPACE
del:
	@rm -rf $(SSH_PATH)/$(WORKSPACE)
	@rm -rf $(TF_PATH_KEY)/$(WORKSPACE)
	@rm -rf $(K8S_PATH)/$(WORKSPACE)
	@rm -rf $(K8S_PATH)/atlantis/$(WORKSPACE)
	
	yc iam service-account delete --name $(WORKSPACE)-$(yandex_service_admin_acc) --folder-name=$(WORKSPACE)
	yc iam service-account delete --name $(WORKSPACE)-$(yandex_service_acc) --folder-name=$(WORKSPACE)

# Задание для окончательной очистки всех созданных файлов
# и удаления бакета хранения настроек бэкенда
purge:
	@rm -rf $(TF_PATH)/.terraform
	@rm -rf $(TF_PATH)/.terraform.lock.hcl
	@rm -rf $(TF-INFRA_PATH)
	@rm -rf $(TF_PATH_KEY)
	@rm -rf $(SSH_PATH)
	@rm -rf $(ATLANTIS_PATH)

	


