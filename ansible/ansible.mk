# Makefile для автоматизации сборки 
.PHONY: all apply gitlab_set_settings monitoring k8s_delete_app

ANSIBLE_INVENTORY = $(WORKSPACE)-inventory

all: apply
apply:
	ansible-playbook -i $(ANSIBLE_INVENTORY) --extra-vars="tf_workspace=$(WORKSPACE)" provision.yml 
gitlab_set_settings:
	ansible-playbook -i $(ANSIBLE_INVENTORY) --extra-vars="tf_workspace=$(WORKSPACE)" --extra-vars="api_token=$(API_TOKEN)" gitlab_set_settings.yml
monitoring:
	ansible-playbook -i $(ANSIBLE_INVENTORY) --extra-vars="tf_workspace=$(WORKSPACE)" monitoring.yml
k8s_delete_app:
	ansible-playbook -i $(ANSIBLE_INVENTORY) --extra-vars="tf_workspace=$(WORKSPACE)" k8s_delete_app.yml
