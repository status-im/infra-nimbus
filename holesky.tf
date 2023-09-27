module "nimbus_nodes_holesky_innova" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "linux"
  env    = "nimbus"
  stage  = "holesky"
  group  = "nimbus-holesky-linux"
  region = "eu-mda1"
  prefix = "ih"
  domain = var.domain

  ips = [
    "194.33.40.71",    # linux-01.ih-eu-mda1.nimbus.holesky
    "194.33.40.81",    # linux-02.ih-eu-mda1.nimbus.holesky
    "194.33.40.82",    # linux-03.ih-eu-mda1.nimbus.holesky
    "194.33.40.107",   # linux-04.ih-eu-mda1.nimbus.holesky
    "194.33.40.129",   # linux-05.ih-eu-mda1.nimbus.holesky
    "194.33.40.130",   # linux-06.ih-eu-mda1.nimbus.holesky
    "194.33.40.131",   # linux-07.ih-eu-mda1.nimbus.holesky
    "194.33.40.140",   # linux-08.ih-eu-mda1.nimbus.holesky
    "194.33.40.141",   # linux-09.ih-eu-mda1.nimbus.holesky
    "194.33.40.147",   # linux-10.ih-eu-mda1.nimbus.holesky
    "194.33.40.148",   # linux-11.ih-eu-mda1.nimbus.holesky
    "194.33.40.149",   # linux-12.ih-eu-mda1.nimbus.holesky
    "194.33.40.151",   # linux-13.ih-eu-mda1.nimbus.holesky
    "194.33.40.157",   # linux-14.ih-eu-mda1.nimbus.holesky
    "194.33.40.241",   # linux-15.ih-eu-mda1.nimbus.holesky
    "194.33.40.242",   # linux-16.ih-eu-mda1.nimbus.holesky
    "194.33.40.243",   # linux-17.ih-eu-mda1.nimbus.holesky
    "194.33.40.244",   # linux-18.ih-eu-mda1.nimbus.holesky
    "194.33.40.245",   # linux-19.ih-eu-mda1.nimbus.holesky
    "194.33.40.246",   # linux-20.ih-eu-mda1.nimbus.holesky
    "194.33.40.247",   # linux-21.ih-eu-mda1.nimbus.holesky
    "194.33.40.248",   # linux-22.ih-eu-mda1.nimbus.holesky
    "194.33.40.249",   # linux-23.ih-eu-mda1.nimbus.holesky
    "194.33.40.250",   # linux-24.ih-eu-mda1.nimbus.holesky
    "194.33.40.251",   # linux-25.ih-eu-mda1.nimbus.holesky
    "194.33.40.252",   # linux-26.ih-eu-mda1.nimbus.holesky
    "194.33.40.253",   # linux-27.ih-eu-mda1.nimbus.holesky
    "194.33.40.254",   # linux-28.ih-eu-mda1.nimbus.holesky
    "185.181.229.100", # linux-29.ih-eu-mda1.nimbus.holesky
    "185.181.229.103", # linux-30.ih-eu-mda1.nimbus.holesky
  ]
}
