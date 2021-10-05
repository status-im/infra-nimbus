locals {
  /* Volumes */
  prater_root_vol_size = 20
  prater_data_vol_size = 50
  prater_data_vol_type = "io1"
  prater_data_vol_iops = 2500
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
  instance_type = local.prater_large_instance_type
  root_vol_size = local.prater_root_vol_size
  data_vol_size = local.prater_data_vol_size
  data_vol_type = local.prater_data_vol_type
  data_vol_iops = local.prater_data_vol_iops
  host_count    = 3

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
  instance_type = local.prater_large_instance_type
  root_vol_size = local.prater_root_vol_size
  data_vol_size = local.prater_data_vol_size
  data_vol_type = local.prater_data_vol_type
  data_vol_iops = local.prater_data_vol_iops
  host_count    = 3

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
  instance_type = local.prater_large_instance_type
  root_vol_size = local.prater_root_vol_size
  data_vol_size = local.prater_data_vol_size
  data_vol_type = local.prater_data_vol_type
  data_vol_iops = local.prater_data_vol_iops
  host_count    = 3

  /* Firewall */
  open_udp_ports = local.nimbus_ports
  open_tcp_ports = local.nimbus_ports

  /* Plumbing */
  vpc_id       = module.nimbus_network.vpc.id
  subnet_id    = module.nimbus_network.subnets[0].id
  secgroup_id  = module.nimbus_network.secgroup.id
  keypair_name = aws_key_pair.arthurk.key_name
}

module "nimbus_nodes_prater_unstable_libp2p_stable_large" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "u-libp2p-s-large"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-unstable-libp2p-stable"
  domain = var.domain

  /* Scaling */
  instance_type = local.prater_large_instance_type
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

module "nimbus_nodes_prater_unstable_libp2p_unstable_large" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "u-libp2p-u-large"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-unstable-libp2p-unstable"
  domain = var.domain

  /* Scaling */
  instance_type = local.prater_large_instance_type
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

module "nimbus_nodes_prater_unstable_windows" {
  source = "github.com/status-im/infra-tf-google-cloud"

  /* Specific */
  name   = "windows"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-windows"
  domain = var.domain
  zone   = "us-central1-a"

  /* System */
  image = "windows-cloud/windows-server-2019-dc-v20210608"
  win_password     = data.pass_password.windows_user_pass.password
  ansible_playbook = "${path.cwd}/ansible/bootstrap-win.yml"

  /* Firewall */
  open_udp_ports = local.nimbus_ports
  open_tcp_ports = local.nimbus_ports

  /* Scaling */
  type          = "c2-standard-8" /* 4 vCPUs, 16GB RAM */
  host_count    = 1
  root_vol_size = 200
  root_vol_type = "pd-ssd"
}

module "nimbus_nodes_prater_hetzner" {
  source = "./modules/dummy-module"

  name   = "metal"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-metal"
  domain = var.domain

  ips = [
    "65.21.73.183", # metal-01.he-eu-hel1.nimbus.prater
    "65.108.5.45",  # metal-02.he-eu-hel1.nimbus.prater
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

  name          = "macos"
  env           = "nimbus"
  stage         = "prater"
  group         = "nimbus-prater-macos"
  region        = "eu-dublin"
  provider_name = "ms"
  domain        = var.domain

  ips = ["207.254.102.130"]
}
