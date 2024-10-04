variable "name" {
  description = "For VPC name"
  type = string
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  description = "CIDR range for vpc"
  type = string
}

variable "pub_subnet" {
  description = "For Public subnet cidr value"
  type = list(string)
}

variable "pri_subnet" {
  description = "For Private subnet cidr value"
  type = list(string)
}

variable "azs" {
  description = "Mention Availability Zones"
  type = list(string)
  default = []
}

variable "single_nat_gw" {
  description = "user need single nat gateway"
  type = bool
  default = false
}

variable "single_nat_rt" {
  description = "user need single nat rt"
  type = bool
  default = false
}