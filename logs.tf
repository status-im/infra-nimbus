module "nimbus_log_store" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "node"
  env    = "log-store"
  group  = "log-store"
  stage  = "nimbus"
  domain = var.domain

  /* Scaling */
  host_count    = var.log_stores_count
  instance_type = "t3a.medium" /* 4GB RAM at least */
  data_vol_size = 200          /* We'll be storing TRACE logs */
  data_vol_type = "st1"        /* Change to gp2 for SSD */

  /* Firewall */
  open_tcp_ports = [
    "80",  /* HTTP */
    "443", /* HTTPS */
  ]

  /* Plumbing */
  vpc_id       = module.nimbus_network.vpc.id
  subnet_id    = module.nimbus_network.subnets[0].id
  secgroup_id  = module.nimbus_network.secgroup.id
  keypair_name = aws_key_pair.jakubgs.key_name
}

resource "cloudflare_record" "nimbus_log_store" {
  zone_id = local.zones["status.im"]
  name    = "nimbus-es.infra"
  value   = module.nimbus_log_store.public_ips[count.index]
  count   = var.log_stores_count
  type    = "A"
  proxied = true
}
