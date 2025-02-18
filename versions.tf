terraform {
  required_version = "> 1.3.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
    }
    aws = {
      source  = "hashicorp/aws"
    }
    pass = {
      source  = "camptocamp/pass"
      version = " = 2.1.1"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
    }
  }
}
