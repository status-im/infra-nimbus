OS = $(strip $(shell uname -s))

ifeq ($(OS),Darwin)
ARCH = darwin_amd64
PROVISIONER_SHA1 = bd688a503f526beedaf6ef5d2dba1128051573b6
else
ARCH = linux_amd64
PROVISIONER_SHA1 = da9cdf019d8f860a6e417257d81b1b21aceba7b7
endif

TF_PLUGINS_DIR = $(HOME)/.terraform.d/plugins

PROVISIONER_NAME = terraform-provisioner-ansible
PROVISIONER_VERSION = v2.5.0
PROVISIONER_ARCHIVE = $(PROVISIONER_NAME)-$(subst _,-,$(ARCH))_$(PROVISIONER_VERSION)
PROVISIONER_URL = https://github.com/radekg/terraform-provisioner-ansible/releases/download/$(PROVISIONER_VERSION)/$(PROVISIONER_ARCHIVE)
PROVISIONER_PATH = $(TF_PLUGINS_DIR)/$(ARCH)/$(PROVISIONER_NAME)_$(PROVISIONER_VERSION)

all: roles-install install-provisioner secrets init-terraform
	@echo "Success!"

roles-install:
	ansible/roles.py --install

roles-check:
	ansible/roles.py --check

roles-update:
	ansible/roles.py --update

roles: roles-install roles-check

$(PROVISIONER_PATH):
	@mkdir -p $(TF_PLUGINS_DIR)/$(ARCH); \
	wget -q $(PROVISIONER_URL) -O $(PROVISIONER_PATH); \
	chmod +x $(PROVISIONER_PATH); \

install-provisioner: $(PROVISIONER_PATH)
	@echo "$(PROVISIONER_SHA1)  $(PROVISIONER_PATH)" | shasum -c \
		|| rm -v $(PROVISIONER_PATH)

secrets:
	pass services/consul/ca-crt > ansible/files/consul-ca.crt
	pass services/consul/client-crt > ansible/files/consul-client.crt
	pass services/consul/client-key > ansible/files/consul-client.key
	pass services/vault/certs/root-ca/cert > ansible/files/vault-ca.crt
	pass services/vault/certs/client-user/cert > ansible/files/vault-client-user.crt
	pass services/vault/certs/client-user/privkey > ansible/files/vault-client-user.key

consul-token-check:
ifndef CONSUL_HTTP_TOKEN
	$(error No CONSUL_HTTP_TOKEN env variable set!)
endif

init-terraform: consul-token-check
	terraform init -upgrade=true

cleanup:
	rm -r $(TF_PLUGINS_DIR)/$(ARCHIVE)
