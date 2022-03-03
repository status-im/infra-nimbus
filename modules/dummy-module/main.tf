/*************************************************
 * WARNING!
 * This is just creating the inventory entries
 * the same way I do it for other hosts so
 * Ansible can use them during provisioning.
 *************************************************/

/* DERIVED --------------------------------------*/

locals {
  stage = var.stage != "" ? var.stage : terraform.workspace
  tokens = split(".", local.stage)
  dc     = "${var.prefix}-${var.region}"
  # map of hostname => ip
  hostnames = { for i, ip in var.ips :
    "${var.name}-${format("%02d", i + 1)}.${local.dc}.${var.env}.${local.stage}" => ip
  }

}

/* RESOURCES ------------------------------------*/

resource "ansible_host" "host" {
  for_each           = local.hostnames
  inventory_hostname = each.key
  groups             = [var.group, local.dc, "${var.env}.${local.stage}"]

  vars = {
    hostname     = each.key
    dns_entry    = "${each.key}.${var.domain}"
    dns_domain   = var.domain
    data_center  = local.dc
    region       = var.region
    env          = var.env
    stage        = local.stage
    ansible_host = each.value
    /* Optional extra Ansible variables necessary for Windows */
    ansible_shell_type    = (var.shell_type    == null ? null : var.shell_type)
    ansible_become_user   = (var.become_user   == null ? null : var.become_user)
    ansible_become_method = (var.become_method == null ? null : var.become_method)
  }
}

resource "cloudflare_record" "host" {
  for_each = local.hostnames

  zone_id = var.zone_id
  name    = each.key
  value   = each.value
  type    = "A"
}
