/* WARNING: These are bootnodes and losing their IPs and private keys would be bad. */
module "nimbus_nodes_mainnet_stable_small" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "stable-small"
  env    = "nimbus"
  stage  = "mainnet"
  group  = "nimbus-mainnet-small"
  domain = var.domain

  /* Scaling */
  instance_type = "t3a.medium"
  root_vol_size = 20
  data_vol_size = 150
  data_vol_type = "gp2"
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

module "nimbus_nodes_mainnet_stable_hetzner" {
  source = "./modules/hetzner"

  name   = "stable-metal"
  env    = "nimbus"
  stage  = "mainnet"
  group  = "nimbus-mainnet-metal"
  domain = var.domain

  ips = [
    "65.21.73.183"
  ]
}
