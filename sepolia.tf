module "nimbus_nodes_sepolia_innova" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "linux"
  env    = "nimbus"
  stage  = "sepolia"
  group  = "nimbus-sepolia-linux"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "185.181.230.77", # linux-01.ih-eu-mda1.nimbus.sepolia
  ]
}

/* Community test REST API endpoints. */
resource "cloudflare_record" "unstable_sepolia_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "unstable.sepolia.beacon-api"
  value   = module.nimbus_nodes_sepolia_innova.public_ips[0]
  type    = "A"
  proxied = false
}
