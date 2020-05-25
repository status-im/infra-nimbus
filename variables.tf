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
  description = "Count of hosts in nimbus cluster."
  default     = 9
}

variable "log_stores_count" {
  description = "Count of ElasticSearch cluster hosts."
  default     = 3
}

/* NIMBUS TEAM -----------------------------------*/

variable "nimbus_team_members" {
  description = "List of Nimbus team members with Console access."
  type        = list(string)
  default     = [ "stefantalpalaru" ]
}
