OS = $(strip $(shell uname -s))

ifeq ($(OS),Darwin)
ARCH = darwin_amd64
PROVISIONER_MD5SUM = 42b93081b1ca548e821020949606eed7
else
ARCH = linux_amd64
PROVISIONER_MD5SUM = 34a6ce3491a5cde370e466a31f6c1f07
endif

TF_PLUGINS_DIR = $(HOME)/.terraform.d/plugins

PROVISIONER_NAME = terraform-provisioner-ansible
PROVISIONER_VERSION = v2.5.0
PROVISIONER_ARCHIVE = $(PROVISIONER_NAME)-$(subst _,-,$(ARCH))_$(PROVISIONER_VERSION)
PROVISIONER_URL = https://github.com/radekg/terraform-provisioner-ansible/releases/download/$(PROVISIONER_VERSION)/$(PROVISIONER_ARCHIVE)
PROVISIONER_PATH = $(TF_PLUGINS_DIR)/$(ARCH)/$(PROVISIONER_NAME)_$(PROVISIONER_VERSION)

all: requirements install-provisioner secrets init-terraform
	@echo "Success!"

requirements:
	ansible-galaxy install --ignore-errors --force -r ansible/requirements.yml

$(PROVISIONER_PATH):
	@mkdir -p $(TF_PLUGINS_DIR)/$(ARCH); \
	wget -q $(PROVISIONER_URL) -O $(PROVISIONER_PATH); \
	chmod +x $(PROVISIONER_PATH); \

install-provisioner: $(PROVISIONER_PATH)
	@echo "$(PROVISIONER_MD5SUM)  $(PROVISIONER_PATH)" | md5sum -c \
		|| rm -v $(PROVISIONER_PATH)

secrets:
	pass services/consul/ca-crt > ansible/files/consul-ca.crt
	pass services/consul/ca-key > ansible/files/consul-ca.key
	pass services/consul/client-crt > ansible/files/consul-client.crt
	pass services/consul/client-key > ansible/files/consul-client.key

init-terraform:
	terraform init -upgrade=true

cleanup:
	rm -r $(TF_PLUGINS_DIR)/$(ARCHIVE)

ssh-config: export SSH_CONFIG_DIR ?= $(HOME)/.ssh/config.d
ssh-config: export SSH_CONFIG_FILE ?= infra-nimbus
ssh-config: export SSH_USERNAME ?= $(USER)
ssh-config:
		scripts/create-ssh-config.sh
