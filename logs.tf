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
    "65.108.226.62", /* store-01.he-eu-hel1.logs.nimbus */
    "65.109.62.247", /* store-02.he-eu-hel1.logs.nimbus */
    "65.109.49.101", /* store-03.he-eu-hel1.logs.nimbus */
  ]
}
