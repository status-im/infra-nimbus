/* For testign Obol DVT setup on Hoodi.
 *
 * Innova Hosting
 * MOB: ProLiant DL380p Gen8
 * CPU: Intel Xeon E5-2667 v3 @ 3.20GHz
 * MEM: 62 GB DDR3
 * SSD: 1x400 GB, 1x1.6 TB */
module "obol_hoodi_innova" {
  source = "github.com/status-im/infra-tf-dummy-module"

  name   = "metal"
  env    = "obol"
  stage  = "hoodi"
  group  = "obol-hoodi-metal"
  region = "eu-mda1"
  prefix = "ih"

  ips = ["194.33.40.237"] # metal-01.ih-eu-mda1.obol.hoodi
}
