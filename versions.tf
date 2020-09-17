terraform {
  required_version = "~> 0.13.3"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = " = 2.10.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = " = 2.46.0"
    }
  }
}
