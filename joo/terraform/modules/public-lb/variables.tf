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
# Load Balancer
################################################################################

variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are `application`, `gateway`, or `network`. The default value is `application`"
  type        = string
  #  default     = "application"
}

variable "public_lb_subnets" {
  description = "ID of public subnet for LB"
  type        = list(string)
  # default     = []
}

################################################################################
# Security Group
################################################################################

variable "public_lb_sg_ports" {
  description = "List of allowed ports to LB Security Group"
  type        = map(any)
  # default     = {}
}

################################################################################
# Dependencies
################################################################################

variable "vpc_id" {
  description = "VPC ID of network module"
  type        = string
  # default     = ""
}