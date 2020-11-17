locals {
  nimbus_ports = [
    "9000-9010", /* Nimbus ports */
    "9100-9110", /* Nimbus ports */
  ]
}

module "nimbus_network" {
  source = "github.com/status-im/infra-tf-aws-vpc"

  name  = "nimbus"
  stage = "test"
  zones = [ "eu-central-1a" ]

  /* Firewall */
  open_udp_ports = local.nimbus_ports
  open_tcp_ports = concat(local.nimbus_ports, [ "22", "80", "443" ])
}
