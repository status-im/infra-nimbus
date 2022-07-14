module "nimbus_log_store" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "store"
  env    = "logs"
  stage  = "nimbus"
  group  = "logs.nimbus"
  region = "eu-hel1"
  prefix = "he"
  domain = var.domain

  ips = [
    "65.108.129.55",
    "65.108.129.56",
    "65.108.129.57",
  ]
}
