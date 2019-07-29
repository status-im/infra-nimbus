/* REQUIRED -------------------------------------*/

variable "cloudflare_token" {
  description = "Token for interacting with Cloudflare API."
}

variable "digitalocean_token" {
  description = "Token for interacting with DigitalOcean API."
}

variable "cloudflare_email" {
  description = "Email address of Cloudflare account."
}

variable "cloudflare_org_id" {
  description = "ID of the CloudFlare organization."
}

variable "alicloud_access_key" {
  description = "Alibaba Cloud API access key."
}

variable "alicloud_secret_key" {
  description = "Alibaba Cloud API secret key."
}

variable "alicloud_region" {
  description = "Alibaba Cloud hosting region."
  default     = "cn-hongkong"
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
