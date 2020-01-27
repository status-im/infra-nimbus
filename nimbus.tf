/* RESOURCES ------------------------------------*/

module "nimbus-master" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "master"
  env    = "nimbus"
  group  = "nimbus-master"
  domain = var.domain

  /* Scaling */
  instance_type = "t3a.medium"
  data_vol_size = 50
  host_count    = 1

  /* Firewall */
  open_tcp_ports = [
    "80",        /* HTTP */
    "443",       /* HTTPS */
    "9000-9010", /* Nimbus ports */
    "9100-9110", /* Nimbus ports */
  ]

  /* Plumbing */
  keypair_name = aws_key_pair.jakubgs.key_name
}

module "nimbus-nodes" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "node"
  env    = "nimbus"
  group  = "nimbus-slaves"
  domain = var.domain

  /* Scaling */
  instance_type = "t3a.medium"
  data_vol_size = 50
  host_count    = var.hosts_count

  /* Firewall */
  open_tcp_ports = [
    "80",        /* HTTP */
    "443",       /* HTTPS */
    "9000-9010", /* beacon node */
    "9100-9110", /* beacon node */
  ]
  
  /* Plumbing */
  keypair_name = aws_key_pair.jakubgs.key_name
}

/* DNS ------------------------------------------*/

resource "cloudflare_record" "nimbus-test-stats" {
  zone_id = local.zones["status.im"]
  name    = "nimbus-test-stats"
  type    = "A"
  proxied = true
  value   = module.nimbus-master.public_ips[count.index]
  count   = length(module.nimbus-master.public_ips)
}

resource "cloudflare_record" "serenity-testnets" {
  zone_id = local.zones["status.im"]
  name    = "serenity-testnets"
  type    = "A"
  proxied = true
  value   = module.nimbus-master.public_ips[count.index]
  count   = length(module.nimbus-master.public_ips)
}
