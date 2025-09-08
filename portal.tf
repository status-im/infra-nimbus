/* Innova Hosting
/* MOB: ProLiant DL380p Gen8
 * CPU: Intel Xeon E5-2667 v3 @ 3.20GHz
 * MEM: 62 GB DDR3
 * SSD: 1x400 GB, 1x1.6 TB */
module "nimbus_nodes_portal_innova" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "metal"
  env    = "nimbus"
  stage  = "portal"
  group  = "nimbus-portal-metal"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "194.33.40.238", # metal-01.ih-eu-mda1.nimbus.portal
    "194.33.40.239", # metal-02.ih-eu-mda1.nimbus.portal
    "82.25.203.2",   # metal-03.ih-eu-mda1.nimbus.portal
    "82.25.203.66",  # metal-04.ih-eu-mda1.nimbus.portal
  ]
}
