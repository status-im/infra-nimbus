/* Node for Rayonism project, which involves
 * multiple short-lived testnets like Steklo. */
module "nimbus_nodes_rayonism_qmerge_large" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "qmerge-large"
  env    = "nimbus"
  stage  = "rayonism"
  group  = "nimbus-rayonism-qmerge"
  domain = var.domain

  /* Scaling */
  instance_type = "z1d.large"
  root_vol_size = 20
  data_vol_size = 30
  data_vol_type = "io1"
  data_vol_iops = 1500
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
