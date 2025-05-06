module "nimbus_nodes_hoodi_innova_geth" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "geth"
  env    = "nimbus"
  stage  = "hoodi"
  group  = "nimbus-hoodi-geth"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "194.33.40.130",   # geth-01.ih-eu-mda1.nimbus.hoodi
    "194.33.40.131",   # geth-02.ih-eu-mda1.nimbus.hoodi
    "194.33.40.140",   # geth-03.ih-eu-mda1.nimbus.hoodi
    "194.33.40.141",   # geth-04.ih-eu-mda1.nimbus.hoodi
    "194.33.40.147",   # geth-05.ih-eu-mda1.nimbus.hoodi
  ]
}

module "nimbus_nodes_hoodi_innova_neth" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "neth"
  env    = "nimbus"
  stage  = "hoodi"
  group  = "nimbus-hoodi-neth"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "194.33.40.148",   # neth-01.ih-eu-mda1.nimbus.hoodi
    "194.33.40.149",   # neth-02.ih-eu-mda1.nimbus.hoodi
    "194.33.40.151",   # neth-03.ih-eu-mda1.nimbus.hoodi
    "194.33.40.157",   # neth-04.ih-eu-mda1.nimbus.hoodi
    "194.33.40.241",   # neth-05.ih-eu-mda1.nimbus.hoodi
  ]
}

module "nimbus_nodes_hoodi_innova_nec" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "nec"
  env    = "nimbus"
  stage  = "hoodi"
  group  = "nimbus-hoodi-nec"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "194.33.40.242",   # nec-01.ih-eu-mda1.nimbus.hoodi
    "194.33.40.243",   # nec-02.ih-eu-mda1.nimbus.hoodi
    "194.33.40.244",   # nec-03.ih-eu-mda1.nimbus.hoodi
    "194.33.40.245",   # nec-04.ih-eu-mda1.nimbus.hoodi
    "194.33.40.246",   # nec-05.ih-eu-mda1.nimbus.hoodi
  ]
}

module "nimbus_nodes_hoodi_innova_macm2" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "macm2"
  env    = "nimbus"
  stage  = "hoodi"
  group  = "nimbus-hoodi-macm2"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "185.181.230.76" # macm2-01.ih-eu-mda1.nimbus.hoodi
  ]
}

module "nimbus_nodes_hoodi_innova_geth_macm2" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "geth-macm2"
  env    = "nimbus"
  stage  = "hoodi"
  group  = "nimbus-hoodi-geth-macm2"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "194.33.40.233", # geth-macm2-01.ih-eu-mda1.nimbus.hoodi
  ]
}

/* Community test REST API endpoints. */
resource "cloudflare_record" "unstable_hoodi_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "unstable.hoodi.beacon-api"
  value   = module.nimbus_nodes_hoodi_innova_geth.public_ips[0]
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "testing_hoodi_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "testing.hoodi.beacon-api"
  value   = module.nimbus_nodes_hoodi_innova_geth.public_ips[1]
  type    = "A"
  proxied = false
}
