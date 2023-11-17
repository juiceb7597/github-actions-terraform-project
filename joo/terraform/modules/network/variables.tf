################################################################################
# Common
################################################################################

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  # default     = ""
}

variable "tags" {
  description = "Additional information for the all resources"
  type        = map(string)
  # default     = ""
}

################################################################################
# VPC
################################################################################

variable "cidr" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
  # default     = "10.0.0.0/16"
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  # default     = []
}

################################################################################
# Public Subnets
################################################################################

variable "public_subnet_cidr" {
  description = "The IPv4 CIDR block for the Public Subnets"
  type        = list(string)
  # default = ["10.0.1.0/24", "10.0.2.0/24"]
}

################################################################################
# WEB Subnets
################################################################################

variable "web_subnet_cidr" {
  description = "The IPv4 CIDR block for the WEB Subnets"
  type        = list(string)
  # default = ["10.0.1.0/24", "10.0.2.0/24"]
}

################################################################################
# Private-LB Subnets
################################################################################

variable "private_lb_subnet_cidr" {
  description = "The IPv4 CIDR block for the Private LB Subnets"
  type        = list(string)
  # default = ["10.0.1.0/24", "10.0.2.0/24"]
}

################################################################################
# WAS Subnets
################################################################################

variable "was_subnet_cidr" {
  description = "The IPv4 CIDR block for the WAS Subnets"
  type        = list(string)
  # default = ["10.0.1.0/24", "10.0.2.0/24"]
}

################################################################################
# DB Subnets
################################################################################

variable "db_subnet_cidr" {
  description = "The IPv4 CIDR block for the DB Subnets"
  type        = list(string)
  # default = ["10.0.1.0/24", "10.0.2.0/24"]
}