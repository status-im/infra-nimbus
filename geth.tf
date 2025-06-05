module "nimbus_geth_holesky" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "holesky"
  env    = "nimbus"
  stage  = "geth"
  group  = "nimbus-geth-holesky"
  region = "eu-mda1"
  prefix = "ih"

  ips = [
    "194.33.40.232", # holesky-01.ih-eu-mda1.nimbus.geth
  ]
}
