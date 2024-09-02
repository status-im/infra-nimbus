/* Innova Hosting
 * MOB: ProLiant DL380p Gen8
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

  ips = ["194.33.40.237"] # metal-01.ih-eu-mda1.nimbus.eth1
}

/* Hetzner
 * Dedicated AX42 Server
 * Location: Finland, HEL1
 * 1 x Primary IPv4
 * 1 x 2 TB NVMe SSD
 * 8 Core CPU
 * 64 GB DDR5 ECC RAM
*/

module "nimbus_eth1_node_benchmark" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "bench"
  env    = "nimbus"
  stage  = "eth1"
  group  = "nimbus-eth1-bench"
  region = "eu-hel1"
  prefix = "he"

  ips = [
    "65.21.46.185", # "bench-01.he-eu-hel1.nimbus.eth1"
    "65.21.46.216"  # "bench-02.he-eu-hel1.nimbus.eth1"
  ]
}
