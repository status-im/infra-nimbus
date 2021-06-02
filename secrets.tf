/* Token for interacting with Cloudflare API. */
data "pass_password" "cloudflare_token" {
  path = "cloud/Cloudflare/token"
}

/* Email address of Cloudflare account. */
data "pass_password" "cloudflare_email" {
  path = "cloud/Cloudflare/email"
}

/* ID of the CloudFlare organization. */
data "pass_password" "cloudflare_account" {
  path = "cloud/Cloudflare/account"
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

/* Windows user bootstrap password */
data "pass_password" "windows_user_pass" {
  path = "hosts/windows-pass"
}
