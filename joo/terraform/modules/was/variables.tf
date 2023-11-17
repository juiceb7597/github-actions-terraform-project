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
# Launch template
################################################################################

variable "instance_type" {
  description = "The type of the instance"
  type        = string
  # default     = ""
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  type        = string
  # default     = null
}

variable "iam_instance_profile_arn" {
  description = "ARN assigned by AWS to the instance profile"
  type        = string
  # default     = null
}

################################################################################
# Autoscaling group
################################################################################

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with `availability_zones`"
  type        = list(string)
  # default     = null
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  type        = string
  # default     = null
}

variable "target_group_arns" {
  description = "A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing"
  type        = string
  # default     = ""
}

variable "health_check_type" {
  description = "`EC2` or `ELB`. Controls how health checking is done"
  type        = string
  # default     = null
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  # default     = null
}

variable "min_size" {
  description = "The minimum size of the autoscaling group"
  type        = number
  # default     = null
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
  type        = number
  # default     = null
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
  type        = number
  # default     = null
}

################################################################################
# Security Group
################################################################################

variable "was_sg_ports" {
  description = "List of allowed ports to WAS Security Group"
  type        = map(any)
  # default     = {}
}

variable "private_lb_sg_id" {
  description = "Security group ID of Private LB for ingress targets"
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

