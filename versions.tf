terraform {
  required_version = "~> 1.3.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = " = 3.26.0"
    }
    pass = {
      source  = "camptocamp/pass"
      version = " = 2.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
    }
  }
}
