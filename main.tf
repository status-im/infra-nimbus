/* PROVIDERS ------------------------------------*/

provider "digitalocean" {
  token = var.digitalocean_token
}

provider "cloudflare" {
  email      = var.cloudflare_email
  api_key    = var.cloudflare_token
  account_id = var.cloudflare_account
}

provider "google" {
  credentials = file("google-cloud.json")
  project     = "russia-servers"
  region      = "us-central1"
}

provider "alicloud" {
  access_key = var.alicloud_access_key
  secret_key = var.alicloud_secret_key
  region     = var.alicloud_region
}

/* DATA -----------------------------------------*/

terraform {
  backend "consul" {
    address = "https://consul.statusim.net:8400"
    lock    = true

    /* KV store has a limit of 512KB */
    gzip = true

    /* WARNING This needs to be changed for every repo. */
    path      = "terraform/nimbus/"
    ca_file   = "ansible/files/consul-ca.crt"
    cert_file = "ansible/files/consul-client.crt"
    key_file  = "ansible/files/consul-client.key"
  }
}

/* CF Zones ------------------------------------*/

/* CloudFlare Zone IDs required for records */
data "cloudflare_zones" "active" {
  filter { status = "active" }
}

/* For easier access to zone ID by domain name */
locals {
  zones = {
    for zone in data.cloudflare_zones.active.zones:
      zone.name => zone.id
  }
}


/* RESOURCES ------------------------------------*/

module "nimbus-master" {
  source     = "github.com/status-im/infra-tf-digital-ocean"

  name       = "master"
  env        = "nimbus"
  group      = "nimbus-master"
  size       = "s-4vcpu-8gb"
  host_count = 1
  domain     = var.domain
  open_ports = [
    "80", /* HTTP */
    "443", /* HTTPS */
    "9000-9010", /* Nimbus ports */
    "9100-9110", /* Nimbus ports */
  ]
}

module "nimbus-nodes" {
  source     = "github.com/status-im/infra-tf-digital-ocean"

  name       = "node"
  env        = "nimbus"
  group      = "nimbus-slaves"
  size       = "s-4vcpu-8gb"
  domain     = var.domain
  host_count = var.hosts_count
  open_ports = [
    "80", /* HTTP */
    "443", /* HTTPS */
    "9000-9010", /* beacon node */
    "9100-9110", /* beacon node */
  ]
}

/* DNS ------------------------------------------*/

resource "cloudflare_record" "nimbus-test-stats" {
  zone_id = local.zones["status.im"]
  name    = "nimbus-test-stats"
  type    = "A"
  proxied = true
  value   = module.nimbus-master.public_ips[count.index]
  count   = length(module.nimbus-master.public_ips)
}

resource "cloudflare_record" "serenity-testnets" {
  zone_id = local.zones["status.im"]
  name    = "serenity-testnets"
  type    = "A"
  proxied = true
  value   = module.nimbus-master.public_ips[count.index]
  count   = length(module.nimbus-master.public_ips)
}

