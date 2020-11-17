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
