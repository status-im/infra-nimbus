locals {
  /* Volumes */
  prater_root_vol_size = 20
  prater_data_vol_size = 150
  prater_data_vol_type = "gp2"
  /* Instances */
  prater_large_instance_type = "z1d.large"
}

module "nimbus_nodes_prater_stable_large" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "stable-large"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-stable"
  domain = var.domain

  /* Scaling */
  type          = local.prater_large_instance_type
  root_vol_size = local.prater_root_vol_size
  data_vol_size = local.prater_data_vol_size
  data_vol_type = local.prater_data_vol_type
  host_count    = 1

  /* Firewall */
  open_udp_ports = local.nimbus_ports
  open_tcp_ports = local.nimbus_ports

  /* Plumbing */
  vpc_id       = module.nimbus_network.vpc.id
  subnet_id    = module.nimbus_network.subnets[0].id
  secgroup_id  = module.nimbus_network.secgroup.id
  keypair_name = aws_key_pair.jakubgs.key_name
}

module "nimbus_nodes_prater_testing_large" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "testing-large"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-testing"
  domain = var.domain

  /* Scaling */
  type          = local.prater_large_instance_type
  root_vol_size = local.prater_root_vol_size
  data_vol_size = local.prater_data_vol_size
  data_vol_type = local.prater_data_vol_type
  host_count    = 1

  /* Firewall */
  open_udp_ports = local.nimbus_ports
  open_tcp_ports = local.nimbus_ports

  /* Plumbing */
  vpc_id       = module.nimbus_network.vpc.id
  subnet_id    = module.nimbus_network.subnets[0].id
  secgroup_id  = module.nimbus_network.secgroup.id
  keypair_name = aws_key_pair.jakubgs.key_name
}

module "nimbus_nodes_prater_unstable_large" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "unstable-large"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-unstable"
  domain = var.domain

  /* Scaling */
  type          = local.prater_large_instance_type
  root_vol_size = local.prater_root_vol_size
  data_vol_size = local.prater_data_vol_size
  data_vol_type = local.prater_data_vol_type
  host_count    = 1

  /* Firewall */
  open_udp_ports = local.nimbus_ports
  open_tcp_ports = local.nimbus_ports

  /* Plumbing */
  vpc_id       = module.nimbus_network.vpc.id
  subnet_id    = module.nimbus_network.subnets[0].id
  secgroup_id  = module.nimbus_network.secgroup.id
  keypair_name = aws_key_pair.jakubgs.key_name
}

module "nimbus_nodes_prater_windows" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "windows"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-windows"
  region = "eu-hel1"
  prefix = "he"
  domain = var.domain

  /* Windows */
  become_user   = "admin"
  become_method = "runas"
  shell_type    = "powershell"

  ips = [
    "65.21.233.67", # windows-01.he-eu-hel1.nimbus.prater
  ]
}

module "nimbus_nodes_prater_hetzner" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "linux"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-metal"
  region = "eu-hel1"
  prefix = "he"
  domain = var.domain

  ips = [
    "95.217.198.113", # linux-01.he-eu-hel1.nimbus.prater
    "95.217.230.20",  # linux-02.he-eu-hel1.nimbus.prater
    "65.108.132.230", # linux-03.he-eu-hel1.nimbus.prater
    "135.181.20.36",  # linux-04.he-eu-hel1.nimbus.prater
    "95.217.224.92",  # linux-05.he-eu-hel1.nimbus.prater
    "95.217.204.216", # linux-06.he-eu-hel1.nimbus.prater
  ]
}

/* Community test REST API endpoints. */
resource "cloudflare_record" "unstable_prater_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "unstable.prater.beacon-api"
  value   = module.nimbus_nodes_prater_hetzner.public_ips[0]
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "testing_prater_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "testing.prater.beacon-api"
  value   = module.nimbus_nodes_prater_hetzner.public_ips[1]
  type    = "A"
  proxied = false
}

module "nimbus_nodes_prater_macos" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "macos"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-macos"
  region = "eu-dublin"
  prefix = "ms"
  domain = var.domain

  ips = ["207.254.102.98"]
}
