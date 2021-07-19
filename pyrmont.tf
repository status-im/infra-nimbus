module "nimbus_nodes_pyrmont_hetzner" {
  source = "./modules/hetzner"

  name   = "metal"
  env    = "nimbus"
  stage  = "pyrmont"
  group  = "nimbus-pyrmont-metal"
  domain = var.domain

  ips = [
    "65.21.196.45",
    "65.21.196.46",
    "65.21.196.47",
    "65.21.196.48",
  ]
}
