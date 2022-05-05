/* Hetzner AX41-NVMe
 * AMD Ryzen 5 3600 Hexa-Core
 * 64 GB DDR4 RAM
 * 2 x 512 GB NVMe SSD
 * 1 x 2 TB NVMe SSD */
module "nimbus_eth1_node_hetzner" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "metal"
  env    = "nimbus"
  stage  = "eth1"
  group  = "nimbus-eth1-metal"
  region = "eu-hel1"
  prefix = "he"
  domain = var.domain

  ips = ["65.21.230.244"]
}
