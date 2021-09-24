/* SCALING --------------------------------------*/

variable "ips" {
  description = "Static list of IPs used by the hosts."
  type        = list(string)
}

variable "region" {
  description = "Region in which the host reside."
  type        = string
  default     = "eu-hel1"
}

variable "provider_name" {
  description = "Short name of provider being used."
  type        = string
  default     = "he"
}

/* SECURITY --------------------------------------*/

variable "ssh_user" {
  description = "Default user for SSH access."
  type        = string
  default     = "root"
}

/* CONFIG ----------------------------------------*/

variable "name" {
  description = "Name for hosts. To be used in the DNS entry."
  type        = string
}

variable "env" {
  description = "Environment for these hosts, affects DNS entries."
  type        = string
}

variable "stage" {
  description = "Name of stage, like prod, dev, or staging."
  type        = string
  default     = ""
}

variable "group" {
  description = "Ansible group to assign hosts to."
  type        = string
}

variable "domain" {
  description = "DNS Domain to update"
  type        = string
}

/* DNS ------------------------------------------*/

/* We default to: statusim.net */
variable "cf_zone_id" {
  description = "ID of CloudFlare zone for host record."
  type        = string
  default     = "14660d10344c9898521c4ba49789f563"
}
