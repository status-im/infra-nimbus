/* MOB: ProLiant DL380p Gen8
 * CPU: Intel Xeon E5-2690 v2 @ 3.00GHz
 * MEM: 62 GB DDR3
 * SSD: 1x400 GB, 2x1.6 TB */
module "nimbus_nodes_mainnet_innova_nec" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "nec"
  env    = "nimbus"
  stage  = "mainnet"
  group  = "nimbus-mainnet-nec"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "194.33.40.70",   /* nec-01.ih-eu-mda1.nimbus.mainnet */
    "194.33.40.72",   /* nec-02.ih-eu-mda1.nimbus.mainnet */
    "194.33.40.78",   /* nec-03.ih-eu-mda1.nimbus.mainnet */
  ]
}

module "nimbus_nodes_mainnet_innova_erigon" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "erigon"
  env    = "nimbus"
  stage  = "mainnet"
  group  = "nimbus-mainnet-erigon"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "194.33.40.99",   /* erigon-01.ih-eu-mda1.nimbus.mainnet */
    "194.33.40.100",  /* erigon-02.ih-eu-mda1.nimbus.mainnet */
  ]
}

module "nimbus_nodes_mainnet_innova_geth" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "geth"
  env    = "nimbus"
  stage  = "mainnet"
  group  = "nimbus-mainnet-geth"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "194.33.40.101",  /* geth-01.ih-eu-mda1.nimbus.mainnet */
    "185.181.229.82", /* geth-02.ih-eu-mda1.nimbus.mainnet */
  ]
}

/* Community test REST API endpoints. */
resource "cloudflare_record" "unstable_mainnet_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "unstable.mainnet.beacon-api"
  value   = module.nimbus_nodes_mainnet_innova_geth.public_ips[0]
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "testing_mainnet_beacon_api" {
  zone_id = local.zones["nimbus.team"]
  name    = "testing.mainnet.beacon-api"
  value   = module.nimbus_nodes_mainnet_innova_geth.public_ips[1]
  type    = "A"
  proxied = false
}

/* WARNING: These are bootnodes and losing their IPs and private keys would be bad. */
module "nimbus_nodes_mainnet_stable_small" {
  source = "github.com/status-im/infra-tf-amazon-web-services"

  name   = "bootstrap"
  env    = "nimbus"
  stage  = "mainnet"
  group  = "nimbus-mainnet-small"

  /* Scaling */
  type          = "t3a.large"
  root_vol_size = 30
  data_vol_size = 1600
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
