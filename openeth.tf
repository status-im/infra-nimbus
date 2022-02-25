/* Hetzner AX41-NVMe
 * AMD Ryzen 5 3600 Hexa-Core
 * 64 GB DDR4 RAM
 * 2 x 512 GB NVMe SSD */
module "nimbus_openeth_mainnet" {
  source = "./modules/dummy-module"

  name   = "mainnet"
  env    = "nimbus"
  stage  = "openeth"
  group  = "nimbus-openeth-mainnet"
  region = "eu-hel1"
  prefix = "he"
  domain = var.domain

  ips = [
    "95.217.120.250", # mainnet-01.he-eu-hel1.nimbus.openeth
  ]
}

