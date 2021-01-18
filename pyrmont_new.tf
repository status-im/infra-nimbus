locals {
  /* Volumes */
  pyrmont_root_vol_size = 20
  pyrmont_data_vol_size = 150
  pyrmont_data_vol_type = "io1"
  pyrmont_data_vol_iops = 2000
  /* Instances */
  pyrmont_large_instance_type = "z1d.large"
  pyrmont_small_instance_type = "t3a.medium"
}

module "nimbus_nodes_pyrmont_stable_large" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "stable-large"
  env    = "nimbus"
  stage  = "pyrmont"
  group  = "nimbus-pyrmont-stable"
  domain = var.domain

  /* Scaling */
  instance_type = local.pyrmont_large_instance_type
  root_vol_size = local.pyrmont_root_vol_size
  data_vol_size = local.pyrmont_data_vol_size
  data_vol_type = local.pyrmont_data_vol_type
  data_vol_iops = local.pyrmont_data_vol_iops
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

module "nimbus_nodes_pyrmont_stable_small" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "stable-small"
  env    = "nimbus"
  stage  = "pyrmont"
  group  = "nimbus-pyrmont-stable"
  domain = var.domain

  /* Scaling */
  instance_type = local.pyrmont_small_instance_type
  root_vol_size = local.pyrmont_root_vol_size
  data_vol_size = local.pyrmont_data_vol_size
  data_vol_type = local.pyrmont_data_vol_type
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

module "nimbus_nodes_pyrmont_testing_large" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "testing-large"
  env    = "nimbus"
  stage  = "pyrmont"
  group  = "nimbus-pyrmont-testing"
  domain = var.domain

  /* Scaling */
  instance_type = local.pyrmont_large_instance_type
  root_vol_size = local.pyrmont_root_vol_size
  data_vol_size = local.pyrmont_data_vol_size
  data_vol_type = local.pyrmont_data_vol_type
  data_vol_iops = local.pyrmont_data_vol_iops
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

module "nimbus_nodes_pyrmont_testing_small" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "testing-small"
  env    = "nimbus"
  stage  = "pyrmont"
  group  = "nimbus-pyrmont-testing"
  domain = var.domain

  /* Scaling */
  instance_type = local.pyrmont_small_instance_type
  root_vol_size = local.pyrmont_root_vol_size
  data_vol_size = local.pyrmont_data_vol_size
  data_vol_type = local.pyrmont_data_vol_type
  host_count    = 4

  /* Firewall */
  open_udp_ports = local.nimbus_ports
  open_tcp_ports = local.nimbus_ports

  /* Plumbing */
  vpc_id       = module.nimbus_network.vpc.id
  subnet_id    = module.nimbus_network.subnets[0].id
  secgroup_id  = module.nimbus_network.secgroup.id
  keypair_name = aws_key_pair.jakubgs.key_name
}

module "nimbus_nodes_pyrmont_unstable_large" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "unstable-large"
  env    = "nimbus"
  stage  = "pyrmont"
  group  = "nimbus-pyrmont-unstable"
  domain = var.domain

  /* Scaling */
  instance_type = local.pyrmont_large_instance_type
  root_vol_size = local.pyrmont_root_vol_size
  data_vol_size = local.pyrmont_data_vol_size
  data_vol_type = local.pyrmont_data_vol_type
  data_vol_iops = local.pyrmont_data_vol_iops
  host_count    = 2

  /* Firewall */
  open_udp_ports = local.nimbus_ports
  open_tcp_ports = local.nimbus_ports

  /* Plumbing */
  vpc_id       = module.nimbus_network.vpc.id
  subnet_id    = module.nimbus_network.subnets[0].id
  secgroup_id  = module.nimbus_network.secgroup.id
  keypair_name = aws_key_pair.jakubgs.key_name
}

module "nimbus_nodes_pyrmont_unstable_small" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "unstable-small"
  env    = "nimbus"
  stage  = "pyrmont"
  group  = "nimbus-pyrmont-unstable"
  domain = var.domain

  /* Scaling */
  instance_type = local.pyrmont_small_instance_type
  root_vol_size = local.pyrmont_root_vol_size
  data_vol_size = local.pyrmont_data_vol_size
  data_vol_type = local.pyrmont_data_vol_type
  host_count    = 4

  /* Firewall */
  open_udp_ports = local.nimbus_ports
  open_tcp_ports = local.nimbus_ports

  /* Plumbing */
  vpc_id       = module.nimbus_network.vpc.id
  subnet_id    = module.nimbus_network.subnets[0].id
  secgroup_id  = module.nimbus_network.secgroup.id
  keypair_name = aws_key_pair.jakubgs.key_name
}

module "nimbus_nodes_pyrmont_unstable_libp2p_small" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "unstable-libp2p-small"
  env    = "nimbus"
  stage  = "pyrmont"
  group  = "nimbus-pyrmont-unstable-libp2p"
  domain = var.domain

  /* Scaling */
  instance_type = local.pyrmont_small_instance_type
  root_vol_size = local.pyrmont_root_vol_size
  data_vol_size = local.pyrmont_data_vol_size
  data_vol_type = local.pyrmont_data_vol_type
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
