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
    "194.33.40.71",  # linux-01.ih-eu-mda1.nimbus.holesky
    "194.33.40.107", # linux-02.ih-eu-mda1.nimbus.holesky
    "194.33.40.129", # linux-03.ih-eu-mda1.nimbus.holesky
    "194.33.40.130", # linux-04.ih-eu-mda1.nimbus.holesky
    "194.33.40.131", # linux-05.ih-eu-mda1.nimbus.holesky
    "194.33.40.140", # linux-06.ih-eu-mda1.nimbus.holesky
    "194.33.40.141", # linux-07.ih-eu-mda1.nimbus.holesky
    "194.33.40.147", # linux-09.ih-eu-mda1.nimbus.holesky
    "194.33.40.148", # linux-09.ih-eu-mda1.nimbus.holesky
    "194.33.40.149", # linux-10.ih-eu-mda1.nimbus.holesky
    "194.33.40.151", # linux-11.ih-eu-mda1.nimbus.holesky
    "194.33.40.157", # linux-12.ih-eu-mda1.nimbus.holesky
    "194.33.40.241", # linux-13.ih-eu-mda1.nimbus.holesky
    "194.33.40.242", # linux-14.ih-eu-mda1.nimbus.holesky
    "194.33.40.243", # linux-15.ih-eu-mda1.nimbus.holesky
    "194.33.40.245", # linux-16.ih-eu-mda1.nimbus.holesky
    "194.33.40.246", # linux-17.ih-eu-mda1.nimbus.holesky
  ]
}
