terraform {
  required_version = "~> 0.14.4"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = " = 2.10.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = " = 2.46.0"
    }
    pass = {
      source  = "camptocamp/pass"
      version = " = 1.4.0"
    }
  }
}
