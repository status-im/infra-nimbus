module "nimbus_log_store" {
  source = "./modules/dummy-module"

  name   = "store"
  env    = "logs"
  stage  = "nimbus"
  group  = "logs.nimbus"
  domain = var.domain

  ips = [
    "65.108.129.55",
    "65.108.129.56",
    "65.108.129.57",
  ]
}

resource "cloudflare_record" "nimbus_log_store" {
  zone_id = local.zones["status.im"]
  name    = "nimbus-es.infra"
  value   = module.nimbus_log_store.public_ips[count.index]
  count   = var.log_stores_count
  type    = "A"
  proxied = true
}
