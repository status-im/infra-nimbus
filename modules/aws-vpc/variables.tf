/* PLUMBING -------------------------------------*/

variable "zone" {
  description = "Availability Zone for VPCs and Subnets"
  type        = string
  default     = "eu-central-1a"
}

variable "vpc_cidr_block" {
  description = "IPv4 address space from Classless Inter-Domain Routing for VPC."
  type        = string
  default     = "172.20.0.0/16"
  # WARNING: We can't use 10.0.0.0/8 here because Tinc VPN already does.
  # Details: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html
}

variable "subnet_cidr_block" {
  description = "Subnet of the VPC CIDR block address space."
  type        = string
  default     = "172.20.1.0/24"
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
