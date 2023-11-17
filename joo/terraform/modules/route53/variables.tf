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
# Route53 Record(s)
################################################################################

variable "public_lb_dns_name" {
  description = "The DNS name of the Public LB"
  type        = string
  # default     = ""
}

variable "public_lb_zone_id" {
  description = "The zone_id of the Public LB to assist with creating DNS records"
  type        = string
  # default     = ""
}

variable "private_lb_dns_name" {
  description = "The DNS name of the Private LB"
  type        = string
  # default     = ""
}

variable "private_lb_zone_id" {
  description = "The zone_id of the Private LB to assist with creating DNS records"
  type        = string
  # default     = ""
}

################################################################################
# Dependencies
################################################################################

variable "vpc_id" {
  description = "VPC ID of network module"
  type        = string
  # default     = ""
}