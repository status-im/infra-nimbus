terraform {
  required_version = "~> 0.14.4"
  required_providers {
    ansible = {
      source  = "nbering/ansible"
      version = " = 1.0.4"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = " = 2.10.1"
    }
  }
}