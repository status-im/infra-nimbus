provider "aws" {
  region     = "eu-central-1"
  access_key = data.pass_password.aws_access_key.password
  secret_key = data.pass_password.aws_secret_key.password
}

provider "digitalocean" {
  token             = data.pass_password.digitalocean_token.password
  spaces_access_id  = data.pass_password.digitalocean_spaces_id.password
  spaces_secret_key = data.pass_password.digitalocean_spaces_key.password
}

provider "google" {
  credentials = data.pass_password.google_cloud_cred_json.full
  project     = "russia-servers"
  region      = "us-central1"
}

provider "cloudflare" {
  email      = data.pass_password.cloudflare_email.password
  api_key    = data.pass_password.cloudflare_token.password
}

# Uses PASSWORD_STORE_DIR environment variable
provider "pass" {}
