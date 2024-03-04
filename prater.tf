module "nimbus_nodes_prater_innova" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "linux"
  env    = "nimbus"
  stage  = "prater"
  group  = "nimbus-prater-metal"
  region = "eu-mda1"
  prefix = "ih"
  domain = var.domain

  ips = [
    "185.181.230.78",  # linux-01.ih-eu-mda1.nimbus.prater
    "185.181.230.79",  # linux-02.ih-eu-mda1.nimbus.prater
  ]
}

/* Community test REST API endpoints. */
resource "cloudflare_record" "unstable_prater_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "unstable.prater.beacon-api"
  value   = module.nimbus_nodes_prater_innova.public_ips[0]
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "testing_prater_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "testing.prater.beacon-api"
  value   = module.nimbus_nodes_prater_innova.public_ips[0]
  type    = "A"
  proxied = false
}

/* ERA Files hosting */
resource "cloudflare_record" "era_prater" {
  zone_id = local.zones["nimbus.team"]
  name    = "prater.era"
  value   = module.nimbus_nodes_prater_innova.public_ips[0]
  type    = "A"
  proxied = true
}
