/* Hetzner AX41-NVMe
 * AMD Ryzen 5 3600 Hexa-Core
 * 64 GB DDR4 RAM
 * 2 x 512 GB NVMe SSD */
module "nimbus_nodes_fluffy_hetzner" {
  source = "github.com/status-im/infra-tf-dummy-module"

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

/* Innova Hosting
/* MOB: ProLiant DL380p Gen8
 * CPU: Intel Xeon E5-2667 v3 @ 3.20GHz
 * MEM: 62 GB DDR3
 * SSD: 1x400 GB, 1x1.6 TB */
module "nimbus_nodes_fluffy_innova" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "metal"
  env    = "nimbus"
  stage  = "fluffy"
  group  = "nimbus-fluffy-metal"
  region = "eu-mda1"
  prefix = "ih"
  domain = var.domain

  ips = [
    "194.33.40.238", # metal-01.ih-eu-mda1.nimbus.fluffy
    "194.33.40.239", # metal-02.ih-eu-mda1.nimbus.fluffy
  ]
}
