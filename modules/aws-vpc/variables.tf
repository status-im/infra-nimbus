/* PLUMBING -------------------------------------*/

variable "zone" {
  description = "Availability Zone for VPCs and Subnets"
  type        = string
  default     = "eu-central-1a"
}

/* FIREWALL--------------------------------------*/

variable "open_tcp_ports" {
  description = "List of TCP port ranges to open."
  type        = list(string)
  default     = []
}

variable "open_udp_ports" {
  description = "List of TCP port ranges to open."
  type        = list(string)
  default     = []
}

/* GENERAL --------------------------------------*/

variable "name" {
  description = "Name to use for VPC elements"
  type        = string
}

variable "stage" {
  description = "Stage to use for VPC elements"
  type        = string
}
