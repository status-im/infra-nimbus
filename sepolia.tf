module "nimbus_nodes_sepolia_hetzner" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "linux"
  env    = "nimbus"
  stage  = "sepolia"
  group  = "nimbus-sepolia-linux"
  region = "eu-hel1"
  prefix = "he"
  domain = var.domain

  ips = [
    "65.21.89.157", # linux-01.he-eu-hel1.nimbus.sepolia
  ]
}

/* Community test REST API endpoints. */
resource "cloudflare_record" "unstable_sepolia_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "unstable.sepolia.beacon-api"
  value   = module.nimbus_nodes_sepolia_hetzner.public_ips[0]
  type    = "A"
  proxied = false
}
