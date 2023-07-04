variable "architecture" {
  type    = string
  default = "arm64"
}

variable "name" {
  type    = string
  default = "NAT"
}

variable "instance_type" {
  type    = string
  default = "c6gn.large"
}

variable "zones" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_route_table_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}
variable "ssh_key_name" {
  type    = string
  default = null
}

variable "vpc_cidr" {
  type = string
}