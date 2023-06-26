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

  ips = ["65.21.230.244"] # metal-01.he-eu-hel1.nimbus.eth1
}

/* Innova Hosting
/* MOB: ProLiant DL380p Gen8
 * CPU: Intel Xeon E5-2667 v3 @ 3.20GHz
 * MEM: 62 GB DDR3
 * SSD: 1x400 GB, 1x1.6 TB */
module "nimbus_eth1_node_innova" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "metal"
  env    = "nimbus"
  stage  = "eth1"
  group  = "nimbus-eth1-metal"
  region = "eu-mda1"
  prefix = "ih"
  domain = var.domain

  ips = ["194.33.40.237"] # metal-01.ih-eu-mda1.nimbus.eth1
}
