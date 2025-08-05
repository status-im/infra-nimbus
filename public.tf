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

resource "cloudflare_record" "era_hoodi" {
  zone_id = local.zones["nimbus.team"]
  name    = "hoodi.era"
  value   = module.nimbus_nodes_hoodi_innova_geth.public_ips[0]
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
  value   = module.nimbus_nodes_mainnet_innova_nec.public_ips[0]
  type    = "A"
  proxied = true
}

/* Nimbus-eth1 DB hosting */

resource "cloudflare_record" "nimbus_eth1_db" {
  zone_id = local.zones["nimbus.team"]
  name    = "eth1-db"
  value   = module.obol_hoodi_innova.public_ips[0]
  type    = "A"
  proxied = true
}
