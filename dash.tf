module "nimbus_dashboard" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "node"
  env    = "dash"
  group  = "log-dash"
  stage  = "nimbus"

  /* Scaling */
  host_count    = 1
  type          = "t3a.medium" /* 4GB RAM at least */
  root_vol_size = 15

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

resource "cloudflare_record" "nimbus_dashboard" {
  zone_id = local.zones["status.im"]
  name    = "nimbus-logs.infra"
  value   = "proxy.infra.status.im"
  type    = "CNAME"
  proxied = false
}
