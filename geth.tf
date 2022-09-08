module "nimbus_geth_mainnet" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "mainnet"
  env    = "nimbus"
  stage  = "geth"
  group  = "nimbus-geth-mainnet"
  domain = var.domain

  /* Scaling */
  type          = "t3a.xlarge"
  root_vol_size = 10
  data_vol_size = 1800
  data_vol_type = "gp2"
  host_count    = 1

  /* Firewall */
  open_tcp_ports = [30303]
  open_udp_ports = [30303]

  /* Plumbing */
  vpc_id       = module.nimbus_network.vpc.id
  subnet_id    = module.nimbus_network.subnets[0].id
  secgroup_id  = module.nimbus_network.secgroup.id
  keypair_name = aws_key_pair.jakubgs.key_name
}

module "nimbus_geth_goerli_metal" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "goerli"
  env    = "nimbus"
  stage  = "geth"
  group  = "nimbus-geth-goerli"
  region = "eu-hel1"
  prefix = "he"
  domain = var.domain

  ips = [
    "65.21.73.183", # goerli-01.he-eu-hel1.nimbus.geth
    "65.21.196.48", # goerli-02.he-eu-hel1.nimbus.geth
    "65.21.196.47", # goerli-03.he-eu-hel1.nimbus.geth
  ]
}
