provider "aws" {
  region     = "eu-central-1"
  access_key = data.pass_password.aws_access_key.password
  secret_key = data.pass_password.aws_secret_key.password
}

provider "cloudflare" {
  email      = data.pass_password.cloudflare_email.password
  api_key    = data.pass_password.cloudflare_token.password
  account_id = data.pass_password.cloudflare_account.password
}

# Uses PASSWORD_STORE_DIR environment variable
provider "pass" {}
