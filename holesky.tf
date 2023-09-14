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
    "12.34.56.78", # linux-01.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-02.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-03.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-04.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-05.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-06.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-07.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-08.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-09.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-10.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-11.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-12.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-13.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-14.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-15.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-16.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-17.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-18.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-19.ih-eu-mda1.nimbus.holesky
    "12.34.56.78", # linux-20.ih-eu-mda1.nimbus.holesky
  ]
}
