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

/* TODO */
