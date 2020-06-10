/* HOSTS ----------------------------------------*/

module "libp2p_interop" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "node"
  env    = "libp2p"
  group  = "libp2p-interop"
  domain = var.domain

  /* Scaling */
  instance_type = "t3a.medium"
  data_vol_size = 30
  host_count    = 5

  /* Firewall */
  open_udp_ports = local.nimbus_ports
  open_tcp_ports = local.nimbus_ports

  /* Plumbing */
  vpc_id       = module.nimbus_network.vpc.id
  subnet_id    = module.nimbus_network.subnets[0].id
  secgroup_id  = module.nimbus_network.secgroup.id
  keypair_name = aws_key_pair.jakubgs.key_name
}
