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
