/* REQUIRED -------------------------------------*/

variable "cloudflare_email" {
  description = "Email address of Cloudflare account."
}

variable "cloudflare_token" {
  description = "Token for interacting with Cloudflare API."
}

variable "cloudflare_account" {
  description = "ID of the CloudFlare organization."
}

variable "aws_access_key" {
  description = "Access key for the AWS API."
}

variable "aws_secret_key" {
  description = "Secret key for the AWS API."
}

variable "aws_zone" {
  description = "Name of the AWS Availability Zone."
  default     = "eu-central-1"
}

/* GENERAL --------------------------------------*/

variable "public_domain" {
  description = "Domain under which the public sites go."
  default     = "status.im"
}

variable "domain" {
  description = "DNS Domain to update"
  default     = "statusim.net"
}

/* RESOURCES ------------------------------------*/

variable "hosts_count" {
  description = "Count of hosts in nimbus cluster"
  default     = 9
}
