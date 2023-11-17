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

#########################################
# RDS
#########################################

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = null
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = null
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  # default     = null
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  # default     = null
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  # default     = false
}

################################################################################
# Security Group
################################################################################

variable "db_sg_ports" {
  description = "List of allowed ports to DB Security Group"
  type        = map(any)
  # default     = {}
}

variable "was_sg_id" {
  description = "Security group ID of WAS for ingress targets"
  type        = string
  # default     = ""
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  # default     = []
}

################################################################################
# Dependencies
################################################################################

variable "vpc_id" {
  description = "VPC ID of network module"
  type        = string
  # default     = ""
}