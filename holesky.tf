module "nimbus_nodes_holesky_innova_geth" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "geth"
  env    = "nimbus"
  stage  = "holesky"
  group  = "nimbus-holesky-geth"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "194.33.40.71",    # geth-01.ih-eu-mda1.nimbus.holesky
    "194.33.40.81",    # geth-02.ih-eu-mda1.nimbus.holesky
    "194.33.40.82",    # geth-03.ih-eu-mda1.nimbus.holesky
    "194.33.40.107",   # geth-04.ih-eu-mda1.nimbus.holesky
    "194.33.40.129",   # geth-05.ih-eu-mda1.nimbus.holesky
  ]
}

module "nimbus_nodes_holesky_innova_neth" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "neth"
  env    = "nimbus"
  stage  = "holesky"
  group  = "nimbus-holesky-neth"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "194.33.40.252",   # neth-01.ih-eu-mda1.nimbus.holesky
    "194.33.40.253",   # neth-02.ih-eu-mda1.nimbus.holesky
    "194.33.40.254",   # neth-03.ih-eu-mda1.nimbus.holesky
    "185.181.229.100", # neth-04.ih-eu-mda1.nimbus.holesky
    "185.181.229.103", # neth-05.ih-eu-mda1.nimbus.holesky
  ]
}

module "nimbus_nodes_holesky_innova_nec" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "nec"
  env    = "nimbus"
  stage  = "holesky"
  group  = "nimbus-holesky-nec"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "194.33.40.247",   # nec-01.ih-eu-mda1.nimbus.holesky
    "194.33.40.248",   # nec-02.ih-eu-mda1.nimbus.holesky
    "194.33.40.249",   # nec-03.ih-eu-mda1.nimbus.holesky
    "194.33.40.250",   # nec-04.ih-eu-mda1.nimbus.holesky
    "194.33.40.251",   # nec-05.ih-eu-mda1.nimbus.holesky
  ]
}

module "nimbus_nodes_holesky_innova_windows" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "windows"
  env    = "nimbus"
  stage  = "holesky"
  group  = "nimbus-holesky-windows"
  region = "eu-mda1"
  prefix = "ih"

  /* Windows */
  become_user   = "admin"
  become_method = "runas"
  shell_type    = "powershell"

  ips = [
    "194.33.40.240" # windows-01.ih-eu-mda1.nimbus.holesky
  ]
}

/* Community test REST API endpoints. */
resource "cloudflare_record" "unstable_holesky_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "unstable.holesky.beacon-api"
  value   = module.nimbus_nodes_holesky_innova_geth.public_ips[0]
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "testing_holesky_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "testing.holesky.beacon-api"
  value   = module.nimbus_nodes_holesky_innova_geth.public_ips[1]
  type    = "A"
  proxied = false
}
