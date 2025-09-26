/* Aztec L2 Sepolia testnet sequencer */
module "nimbus_nodes_aztec_sepolia_innova" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "metal"
  env    = "aztec"
  stage  = "sepolia"
  group  = "aztec-sepolia-linux"
  region = "eu-hel1"
  prefix = "he"

  ips = [
    "65.108.13.84",  /* metal-01.he-eu-hel1.aztec.sepolia (AX41-NVMe) */
  ]
}
