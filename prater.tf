locals {
  /* Volumes */
  prater_root_vol_size = 20
  prater_data_vol_size = 300
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

module "nimbus_nodes_prater_innova" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "linux"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-metal"
  region = "eu-mda1"
  prefix = "ih"
  domain = var.domain

  ips = [
    "185.181.230.78",  # linux-01.ih-eu-mda1.nimbus.prater
    "185.181.230.79",  # linux-02.ih-eu-mda1.nimbus.prater
    "185.181.230.121", # linux-03.ih-eu-mda1.nimbus.prater
    "194.33.40.231",   # linux-04.ih-eu-mda1.nimbus.prater
    "194.33.40.232",   # linux-05.ih-eu-mda1.nimbus.prater
    "194.33.40.233",   # linux-06.ih-eu-mda1.nimbus.prater
  ]
}

/* Community test REST API endpoints. */
resource "cloudflare_record" "unstable_prater_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "unstable.prater.beacon-api"
  value   = module.nimbus_nodes_prater_innova.public_ips[0]
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "testing_prater_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "testing.prater.beacon-api"
  value   = module.nimbus_nodes_prater_innova.public_ips[1]
  type    = "A"
  proxied = false
}

/* ERA Files hosting */
resource "cloudflare_record" "era_prater" {
  zone_id = local.zones["nimbus.team"]
  name    = "prater.era"
  value   = module.nimbus_nodes_prater_innova.public_ips[0]
  type    = "A"
  proxied = true
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
