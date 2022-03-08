/* Hetzner AX41-NVMe
 * AMD Ryzen 5 3600 Hexa-Core
 * 64 GB DDR4 RAM
 * 2 x 512 GB NVMe SSD */
module "nimbus_nodes_fluffy_hetzner" {
  source = "./modules/dummy-module"

  name   = "metal"
  env    = "nimbus"
  stage  = "fluffy"
  group  = "nimbus-fluffy-metal"
  region = "eu-hel1"
  prefix = "he"
  domain = var.domain

  ips = [
    "65.108.42.3",   # metal-01.he-eu-hel1.nimbus.fluffy
    "65.108.42.174", # metal-02.he-eu-hel1.nimbus.fluffy
  ]
}
