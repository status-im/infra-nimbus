/* Hetzner AX41-NVMe
 * AMD Ryzen 5 3600 Hexa-Core
 * 64 GB DDR4 RAM
 * 2 x 512 GB NVMe SSD */
module "nimbus_nodes_mainnet_hetzner" {
  source = "./modules/dummy-module"

  name   = "metal"
  env    = "nimbus"
  stage  = "mainnet"
  group  = "nimbus-mainnet-metal"
  domain = var.domain

  ips = [
    "95.217.87.121",
    "135.181.0.33",
    "135.181.60.170",
    "65.21.193.229",
    "135.181.60.177",
    "135.181.56.50",
  ]
}

/* Community test REST API endpoints. */
resource "cloudflare_record" "unstable_mainnet_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "unstable.mainnet.beacon-api"
  value   = module.nimbus_nodes_mainnet_hetzner.public_ips[0]
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "testing_mainnet_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "testing.mainnet.beacon-api"
  value   = module.nimbus_nodes_mainnet_hetzner.public_ips[1]
  type    = "A"
  proxied = false
}

/* WARNING: These are bootnodes and losing their IPs and private keys would be bad. */
module "nimbus_nodes_mainnet_stable_small" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "stable-small"
  env    = "nimbus"
  stage  = "mainnet"
  group  = "nimbus-mainnet-small"
  domain = var.domain

  /* Scaling */
  instance_type = "t3a.medium"
  root_vol_size = 20
  data_vol_size = 150
  data_vol_type = "gp2"
  host_count    = 2

  /* Firewall */
  open_udp_ports = local.nimbus_ports
  open_tcp_ports = local.nimbus_ports

  /* Plumbing */
  vpc_id       = module.nimbus_network.vpc.id
  subnet_id    = module.nimbus_network.subnets[0].id
  secgroup_id  = module.nimbus_network.secgroup.id
  keypair_name = aws_key_pair.jakubgs.key_name
}
