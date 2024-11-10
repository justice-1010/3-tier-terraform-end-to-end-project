variable "vpc_cidr_block" {
    type = string
}

variable "public_cidr_block" {
  type = list(string)
}

variable "availabity_zone" {
  type = list(string)
}

variable "private_cidr_block" {
  type = list(string)
}