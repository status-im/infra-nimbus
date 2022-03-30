module "nimbus_nodes_kiln_hetzner" {
  source = "./modules/dummy-module"

  name   = "metal"
  env    = "nimbus"
  stage  = "kiln"
  group  = "nimbus-kiln-metal"
  region = "eu-hel1"
  prefix = "he"
  domain = var.domain

  ips = [
    "65.21.89.157", # metal-01.he-eu-hel1.nimbus.kiln
  ]
}

/* Community test REST API endpoints. */
resource "cloudflare_record" "unstable_kiln_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "unstable.kiln.beacon-api"
  value   = module.nimbus_nodes_kiln_hetzner.public_ips[0]
  type    = "A"
  proxied = false
}
