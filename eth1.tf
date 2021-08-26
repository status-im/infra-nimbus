module "nimbus_eth1_node_hetzner" {
  source = "./modules/hetzner"

  name   = "metal"
  env    = "nimbus"
  stage  = "eth1"
  group  = "nimbus-eth1-metal"
  domain = var.domain

  ips = ["65.21.230.244"]
}
