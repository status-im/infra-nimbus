/* Hetzner
 * Dedicated AX41-NVMe Server
 * Location: Finland, HEL1-DC5
 * 1 x Primary IPv4
 * 2 x 512 GB NVMe SSD
 * 6 Core CPU
 * 64 GB DDR4 RAM
*/

module "ethereum_hive_testing" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "node"
  env    = "nimbus"
  stage  = "hive"
  group  = "ethereum_hive_testing"
  region = "eu-hel1"
  prefix = "he"

  ips = [
    "65.109.22.181", # "node-01.he-eu-hel1.nimbus.hive"
  ]
}
