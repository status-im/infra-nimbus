module "nimbus_nodes_ropsten_hetzner" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "metal"
  env    = "nimbus"
  stage  = "ropsten"
  group  = "nimbus-ropsten-metal"
  region = "eu-hel1"
  prefix = "he"
  domain = var.domain

  ips = [
    "135.181.57.169", # metal-01.he-eu-hel1.nimbus.ropsten
  ]
}
