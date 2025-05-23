module "nimbus_geth_mainnet" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "mainnet"
  env    = "nimbus"
  stage  = "geth"
  group  = "nimbus-geth-mainnet"

  /* Scaling */
  type          = "t3a.xlarge"
  root_vol_size = 10
  data_vol_size = 2500
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

module "nimbus_geth_holesky" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "holesky"
  env    = "nimbus"
  stage  = "geth"
  group  = "nimbus-geth-holesky"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "194.33.40.232", # holesky-01.ih-eu-mda1.nimbus.geth
  ]
}
