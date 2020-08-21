/* NETWORK --------------------------------------*/

locals {
  nimbus_ports = [
    "9000-9010", /* Nimbus ports */
    "9100-9110", /* Nimbus ports */
  ]
}

module "nimbus_network" {
  source = "github.com/status-im/infra-tf-aws-vpc"

  name  = "nimbus"
  stage = "test"
  zones = [ "eu-central-1a" ]

  /* Firewall */
  open_udp_ports = local.nimbus_ports
  open_tcp_ports = concat(local.nimbus_ports, [ "22", "80", "443" ])
}

/* HOSTS ----------------------------------------*/

module "nimbus_master" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "master"
  env    = "nimbus"
  group  = "nimbus-master"
  domain = var.domain

  /* Scaling */
  instance_type = "t3a.medium"
  data_vol_size = 150
  host_count    = 1

  /* Firewall */
  open_udp_ports = local.nimbus_ports
  open_tcp_ports = concat(local.nimbus_ports, [ "80", "443" ])

  /* Plumbing */
  vpc_id       = module.nimbus_network.vpc.id
  subnet_id    = module.nimbus_network.subnets[0].id
  secgroup_id  = module.nimbus_network.secgroup.id
  keypair_name = aws_key_pair.jakubgs.key_name
}

module "nimbus_nodes" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "node"
  env    = "nimbus"
  group  = "nimbus-slaves"
  domain = var.domain

  /* Scaling */
  instance_type = "t3a.medium"
  data_vol_size = 150
  host_count    = var.hosts_count

  /* Firewall */
  open_udp_ports = local.nimbus_ports
  open_tcp_ports = local.nimbus_ports

  /* Plumbing */
  vpc_id       = module.nimbus_network.vpc.id
  subnet_id    = module.nimbus_network.subnets[0].id
  secgroup_id  = module.nimbus_network.secgroup.id
  keypair_name = aws_key_pair.jakubgs.key_name
}

/* DNS ------------------------------------------*/

resource "cloudflare_record" "nimbus_test_stats" {
  zone_id = local.zones["status.im"]
  name    = "nimbus-test-stats"
  type    = "A"
  proxied = true
  value   = module.nimbus_master.public_ips[count.index]
  count   = length(module.nimbus_master.public_ips)
}

resource "cloudflare_record" "serenity_testnets" {
  zone_id = local.zones["status.im"]
  name    = "serenity-testnets"
  type    = "A"
  proxied = true
  value   = module.nimbus_master.public_ips[count.index]
  count   = length(module.nimbus_master.public_ips)
}
