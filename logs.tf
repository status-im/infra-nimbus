module "nimbus_logs_store" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "store"
  env    = "nimbus"
  stage  = "logs"
  group  = "nimbus-logs-store"
  region = "eu-hel1"
  prefix = "he"
  type   = "AX101"

  ips = [
    "65.108.226.62", /* store-01.he-eu-hel1.nimbus.logs */
    "65.109.62.247", /* store-02.he-eu-hel1.nimbus.logs */
    "65.109.49.101", /* store-03.he-eu-hel1.nimbus.logs */
  ]
}
