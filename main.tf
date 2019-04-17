/* DERIVED --------------------------------------*/
provider "digitalocean" {
  token   = "${var.digitalocean_token}"
  version = "<= 0.1.3"
}
provider "cloudflare" {
  email  = "${var.cloudflare_email}"
  token  = "${var.cloudflare_token}"
  org_id = "${var.cloudflare_org_id}"
}
provider "google" {
  credentials = "${file("google-cloud.json")}"
  project     = "russia-servers"
  region      = "us-central1"
}
provider "alicloud" {
  access_key = "${var.alicloud_access_key}"
  secret_key = "${var.alicloud_secret_key}"
  region     = "${var.alicloud_region}"
}

/* DATA -----------------------------------------*/

terraform {
  backend "consul" {
    address   = "https://consul.statusim.net:8400"
    lock      = true
    /* KV store has a limit of 512KB */
    gzip      = true
    /* WARNING This needs to be changed for every repo. */
    path      = "terraform/nimbus/"
    ca_file   = "ansible/files/consul-ca.crt"
    cert_file = "ansible/files/consul-client.crt"
    key_file  = "ansible/files/consul-client.key"
  }
}

/* RESOURCES ------------------------------------*/

module "nimbus-master" {
  source = "github.com/status-im/infra-tf-digital-ocean"
  name   = "master"
  env    = "nimbus"
  group  = "nimbus-master"
  size   = "s-4vcpu-8gb"
  count  = 1
  domain = "${var.domain}"
  open_ports = [
    "80",        /* HTTP */
    "443",       /* HTTPS */
    "9630-9633", /* Nimbus ports */
  ]
}

resource "cloudflare_record" "nimbus-test-stats" {
  domain  = "${var.public_domain}"
  name    = "nimbus-test-stats"
  type    = "A"
  proxied = true
  value   = "${module.nimbus-master.public_ips[0]}"
}

resource "cloudflare_record" "serenity-testnets" {
  domain  = "${var.public_domain}"
  name    = "serenity-testnets"
  type    = "A"
  proxied = true
  value   = "${module.nimbus-master.public_ips[0]}"
}

module "nimbus-nodes" {
  source = "github.com/status-im/infra-tf-digital-ocean"
  name   = "node"
  env    = "nimbus"
  group  = "nimbus-slaves"
  size   = "s-4vcpu-8gb"
  domain = "${var.domain}"
  count  = "${var.hosts_count}"
  open_ports = [
    "80",        /* HTTP */
    "443",       /* HTTPS */
    "40404",     /* peer connection */
    "9100-9110", /* beacon node */
  ]
}
