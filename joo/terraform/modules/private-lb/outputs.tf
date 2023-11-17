################################################################################
# Load Balancer
################################################################################

output "id" {
  description = "The ID and ARN of the load balancer we created"
  value       = try(aws_lb.private.id, null)
}

output "arn" {
  description = "The ID and ARN of the load balancer we created"
  value       = try(aws_lb.private.arn, null)
}

output "arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch"
  value       = try(aws_lb.private.arn_suffix, null)
}

output "dns_name" {
  description = "The DNS name of the load balancer"
  value       = try(aws_lb.private.dns_name, null)
}

output "zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = try(aws_lb.private.zone_id, null)
}

################################################################################
# Target Group(s)
################################################################################

output "target_groups" {
  description = "Map of target groups created and their attributes"
  value       = aws_lb_target_group.was
}

output "target_groups_arn" {
  description = "A ARN of target groups"
  value       = aws_lb_target_group.was.arn
}

################################################################################
# Security Group
################################################################################

output "security_group_arn" {
  description = "Amazon Resource Name (ARN) of the security group"
  value       = try(aws_security_group.private_lb.arn, null)
}

output "security_group_id" {
  description = "ID of the security group"
  value       = try(aws_security_group.private_lb.id, null)
}
