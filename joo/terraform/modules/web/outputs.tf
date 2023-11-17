################################################################################
# Launch template
################################################################################

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = try(aws_launch_template.web.id, null)
}

output "launch_template_arn" {
  description = "The ARN of the launch template"
  value       = try(aws_launch_template.web.arn, null)
}

output "launch_template_name" {
  description = "The name of the launch template"
  value       = try(aws_launch_template.web.name, null)
}

output "launch_template_default_version" {
  description = "The default version of the launch template"
  value       = try(aws_launch_template.web.default_version, null)
}

################################################################################
# Autoscaling group
################################################################################

output "autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = try(aws_autoscaling_group.web.id, null)
}

output "autoscaling_group_name" {
  description = "The autoscaling group name"
  value       = try(aws_autoscaling_group.web.name, null)
}

output "autoscaling_group_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = try(aws_autoscaling_group.web.arn, null)
}

output "autoscaling_group_min_size" {
  description = "The minimum size of the autoscale group"
  value       = try(aws_autoscaling_group.web.min_size, null)
}

output "autoscaling_group_max_size" {
  description = "The maximum size of the autoscale group"
  value       = try(aws_autoscaling_group.web.max_size, null)
}

output "autoscaling_group_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = try(aws_autoscaling_group.web.desired_capacity, null)
}

output "autoscaling_group_default_cooldown" {
  description = "Time between a scaling activity and the succeeding scaling activity"
  value       = try(aws_autoscaling_group.web.default_cooldown, null)
}

output "autoscaling_group_health_check_grace_period" {
  description = "Time after instance comes into service before checking health"
  value       = try(aws_autoscaling_group.web.health_check_grace_period, null)
}

output "autoscaling_group_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
  value       = try(aws_autoscaling_group.web.health_check_type, null)
}

output "autoscaling_group_availability_zones" {
  description = "The availability zones of the autoscale group"
  value       = try(aws_autoscaling_group.web.availability_zones, [])
}

output "autoscaling_group_load_balancers" {
  description = "The load balancer names associated with the autoscaling group"
  value       = try(aws_autoscaling_group.web.load_balancers, [])
}

output "autoscaling_group_target_group_arns" {
  description = "List of Target Group ARNs that apply to this AutoScaling Group"
  value       = try(aws_autoscaling_group.web.target_group_arns, [])
}

################################################################################
# Security Group
################################################################################

output "security_group_arn" {
  description = "The ARN of the security group"
  value       = try(aws_security_group.web.arn, "")
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = try(aws_security_group.web.id, "")
}

output "security_group_vpc_id" {
  description = "The VPC ID"
  value       = try(aws_security_group.web.vpc_id, "")
}

output "security_group_owner_id" {
  description = "The owner ID"
  value       = try(aws_security_group.web.owner_id, "")
}

output "security_group_name" {
  description = "The name of the security group"
  value       = try(aws_security_group.web.name, "")
}

output "security_group_description" {
  description = "The description of the security group"
  value       = try(aws_security_group.web.description, "")
}