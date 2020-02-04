/* PROVIDERS ------------------------------------*/

provider "aws" {
  version    = "~> 2.0"
  region     = var.aws_zone
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "cloudflare" {
  email      = var.cloudflare_email
  api_key    = var.cloudflare_token
  account_id = var.cloudflare_account
}

/* DATA -----------------------------------------*/

terraform {
  backend "consul" {
    address = "https://consul.statusim.net:8400"
    /* Lock to avoid syncing issues */
    lock = true
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

/* ACCESS KEY ------------------------------------------------------*/

resource "aws_key_pair" "jakubgs" {
  key_name   = "jakubgs"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDA6mutbRHO8VvZ61MYvjIVv1Re9NiJGE1piTQq4IFwXOvAi1HkXkMlsjmzYt+CEv0HmMGCHmdrw5xpqnDTWg18lM5RYLzrAv9hBOQ10IC+8FH2XWDKoyz+PBQsNEbbJ23QQtu0O5mpsOzI/KBT9CkiYUYlEBwHI0vNqsdHDLwv3Yt7PhauguXDHpYnwH/OseVHLBg2+/3aJIfOMVVRnhptQGYAhTNUZ9F1EwvQETMhM/vEsk8+o9B3tK/Ii/RD2EtVUlpRG4q6QTFbssLMImUfcdoggHsfCqjq3apUs8bR81oN9UVoYiP8tn5sWIUyRBxIEzXpqa4rx04KY8xNYqeZ jakub@status.im"
}
