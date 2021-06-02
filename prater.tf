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
  host_count    = 5

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
  host_count    = 5

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
  host_count    = 5

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
  image            = "windows-cloud/windows-server-2019-dc-core-v20210511"
  win_password     = data.pass_password.windows_user_pass.password
  ansible_playbook = "${path.cwd}/ansible/bootstrap-win.yml"

  /* Scaling */
  type          = "n2-standard-2" /* 2 vCPUs, 8GB RAM */
  host_count    = 1
  root_vol_size = 80
  root_vol_type = "pd-ssd"
}
