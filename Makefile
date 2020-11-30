OS = $(strip $(shell uname -s))
ARCH = linux_amd64
PLATFORM = linux
ifeq ($(OS),Darwin)
	ARCH = darwin_amd64
	PLATFORM = darwin
endif

PLUGIN_DIR = ~/.terraform.d/plugins

PROVISIONER_NAME = terraform-provisioner-ansible
PROVISIONER_VERSION = v2.3.0
PROVISIONER_ARCHIVE = $(PROVISIONER_NAME)-$(subst _,-,$(ARCH))_$(PROVISIONER_VERSION)
PROVISIONER_URL = https://github.com/radekg/terraform-provisioner-ansible/releases/download/$(PROVISIONER_VERSION)/$(PROVISIONER_ARCHIVE)

all: requirements install-provisioner secrets init-terraform
	@echo "Success!"

plugins: install-provisioner

requirements:
	ansible-galaxy install --ignore-errors --force -r ansible/requirements.yml

install-provisioner:
	if [ ! -e $(PLUGIN_DIR)/$(ARCH)/$(PROVISIONER_NAME)_$(PROVISIONER_VERSION) ]; then \
		mkdir -p $(PLUGIN_DIR); \
		wget $(PROVISIONER_URL) -O $(PLUGIN_DIR)/$(ARCH)/$(PROVISIONER_NAME)_$(PROVISIONER_VERSION); \
		chmod +x $(PLUGIN_DIR)/$(ARCH)/$(PROVISIONER_NAME)_$(PROVISIONER_VERSION); \
	fi

init-terraform:
	terraform init -upgrade=true

SSH_CONFIG_DIR := ~/.ssh/config.d
SSH_CONFIG_FILE := infra-nimbus
SSH_USERNAME := $$(whoami)

ssh-config:
	SSH_CONFIG_DIR=$(SSH_CONFIG_DIR) \
	SSH_CONFIG_FILE=$(SSH_CONFIG_FILE) \
	SSH_USERNAME=$(SSH_USERNAME) \
	bash scripts/create-ssh-config.sh

secrets:
	@echo "Saving Consul certificates: ansible/files/consul*"
	pass services/consul/ca-crt > ansible/files/consul-ca.crt
	pass services/consul/ca-key > ansible/files/consul-ca.key
	pass services/consul/client-crt > ansible/files/consul-client.crt
	pass services/consul/client-key > ansible/files/consul-client.key

cleanup:
	rm -r $(PLUGIN_DIR)/$(ARCHIVE)
