terraform {
  required_version = "~> 1.0.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = " = 2.21.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = " = 3.46.0"
    }
    pass = {
      source  = "camptocamp/pass"
      version = " = 2.0.0"
    }
  }
}
