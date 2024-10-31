/* ERA Files hosting */

resource "cloudflare_record" "era_sepolia" {
  zone_id = local.zones["nimbus.team"]
  name    = "sepolia.era"
  value   = module.nimbus_nodes_sepolia_innova.public_ips[0]
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "era_mainnet" {
  zone_id = local.zones["nimbus.team"]
  name    = "mainnet.era"
  value   = module.nimbus_nodes_mainnet_innova_erigon.public_ips[0]
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "era_holesky" {
  zone_id = local.zones["nimbus.team"]
  name    = "holesky.era"
  value   = module.nimbus_nodes_holesky_innova_geth.public_ips[0]
  type    = "A"
  proxied = true
}

/* ERA1 Files hosting */

resource "cloudflare_record" "era1_sepolia" {
  zone_id = local.zones["nimbus.team"]
  name    = "sepolia.era1"
  value   = module.nimbus_nodes_sepolia_innova.public_ips[0]
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "era1_mainnet" {
  zone_id = local.zones["nimbus.team"]
  name    = "mainnet.era1"
  value   = module.nimbus_nodes_mainnet_innova_nel.public_ips[0]
  type    = "A"
  proxied = true
}
