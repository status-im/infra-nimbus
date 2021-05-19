/*************************************************
 * WARNING!
 * This is not a Terraform provider for Hetzner.
 * I'm just creating the inventory entries
 * the same way I do it for other hosts so
 * Ansible can use them during provisioning.
 *************************************************/

/* DERIVED --------------------------------------*/

locals {
  stage = var.stage != "" ? var.stage : terraform.workspace
  tokens = split(".", local.stage)
  dc     = "${var.provider_name}-${var.region}"

  # map of ip => hostname
  hostnames = { for i, ip in var.ips :
    ip => "${var.name}-${format("%02d", i + 1)}.${local.dc}.${var.env}.${local.stage}"
  }
}

/* RESOURCES ------------------------------------*/

resource "ansible_host" "host" {
  for_each           = local.hostnames
  inventory_hostname = each.value
  groups             = [var.group, local.dc, "${var.env}.${local.stage}"]
  vars = {
    ansible_host     = each.key
    hostname         = each.value
    region           = var.region
    dns_domain       = var.domain
    dns_entry        = "${each.value}.${var.domain}"
    data_center      = local.dc
    stage            = local.stage
    env              = var.env
  }
}

resource "cloudflare_record" "host" {
  for_each = local.hostnames
  zone_id  = var.cf_zone_id
  name     = each.value // hostname
  value    = each.key   // ip
  type     = "A"
  ttl      = 3600
}
