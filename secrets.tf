/* Token for interacting with Cloudflare API. */
data "pass_password" "cloudflare_token" {
  path = "cloud/Cloudflare/token"
}

/* Email address of Cloudflare account. */
data "pass_password" "cloudflare_email" {
  path = "cloud/Cloudflare/email"
}

/* Access key for the AWS API. */
data "pass_password" "aws_access_key" {
  path = "cloud/AWS/Nimbus/access-key"
}

/* Secret key for the AWS API. */
data "pass_password" "aws_secret_key" {
  path = "cloud/AWS/Nimbus/secret-key"
}

/* Google Cloud API auth JSON */
data "pass_password" "google_cloud_cred_json" {
  path = "cloud/GoogleCloud/json"
}

/* Token for interacting with DigitalOcean API. */
data "pass_password" "digitalocean_token" {
  path = "cloud/DigitalOcean/token"
}

/* Access key for Digital Ocean Spaces API. */
data "pass_password" "digitalocean_spaces_id" {
  path = "cloud/DigitalOcean/spaces-id"
}

/* Secret key for Digital Ocean Spaces API. */
data "pass_password" "digitalocean_spaces_key" {
  path = "cloud/DigitalOcean/spaces-key"
}
