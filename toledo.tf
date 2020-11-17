module "nimbus_nodes_toledo" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "toledo"
  env    = "nimbus"
  group  = "nimbus-slaves-toledo"
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
