/* Hetzner AX41-NVMe
 * AMD Ryzen 5 3600 Hexa-Core
 * 64 GB DDR4 RAM
 * 2 x 512 GB NVMe SSD */
module "nimbus_nodes_pyrmont_hetzner" {
  source = "./modules/dummy-module"

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
