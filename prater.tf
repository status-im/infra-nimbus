locals {
  /* Volumes */
  prater_root_vol_size = 20
  prater_data_vol_size = 100
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
  keypair_name = aws_key_pair.arthurk.key_name
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
  keypair_name = aws_key_pair.arthurk.key_name
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
  keypair_name = aws_key_pair.arthurk.key_name
}

module "nimbus_nodes_prater_windows" {
  source = "./modules/dummy-module"

  name   = "windows"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-windows"
  region = "eu-hel1"
  prefix = "he"
  domain = var.domain

  /* Windows */
  become     = false
  shell_type = "powershell"

  ips = [
    "65.21.233.67", # windows-01.he-eu-hel1.nimbus.prater
  ]
}

module "nimbus_nodes_prater_hetzner" {
  source = "./modules/dummy-module"

  name   = "metal"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-metal"
  region = "eu-hel1"
  prefix = "he"
  domain = var.domain

  ips = [
    "65.21.73.183", # metal-01.he-eu-hel1.nimbus.prater
    "65.108.5.45",  # metal-02.he-eu-hel1.nimbus.prater
    "65.21.196.47", # metal-03.he-eu-hel1.nimbus.prater
    "65.21.196.48", # metal-04.he-eu-hel1.nimbus.prater
    "65.21.92.118", # metal-05.he-eu-hel1.nimbus.prater
    "65.21.91.59",  # metal-06.he-eu-hel1.nimbus.prater
    "65.21.89.157", # metal-07.he-eu-hel1.nimbus.prater
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
  source = "./modules/dummy-module"

  name   = "macos"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-macos"
  region = "eu-dublin"
  prefix = "ms"
  domain = var.domain

  ips = ["207.254.102.98"]
}
