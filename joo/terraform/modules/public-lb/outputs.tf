################################################################################
# Load Balancer
################################################################################

output "id" {
  description = "The ID and ARN of the load balancer we created"
  value       = try(aws_lb.public.id, null)
}

output "arn" {
  description = "The ID and ARN of the load balancer we created"
  value       = try(aws_lb.public.arn, null)
}

output "arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch"
  value       = try(aws_lb.public.arn_suffix, null)
}

output "dns_name" {
  description = "The DNS name of the load balancer"
  value       = try(aws_lb.public.dns_name, null)
}

output "zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = try(aws_lb.public.zone_id, null)
}
################################################################################
# Listener(s)
################################################################################

output "listeners_http" {
  description = "Map of listeners created and their attributes"
  value       = aws_lb_listener.http
}

output "listeners_https" {
  description = "Map of listeners created and their attributes"
  value       = aws_lb_listener.https
}

################################################################################
# Target Group(s)
################################################################################

output "target_groups" {
  description = "Map of target groups created and their attributes"
  value       = aws_lb_target_group.web
}

output "target_groups_arn" {
  description = "A ARN of target groups"
  value       = aws_lb_target_group.web.arn
}

################################################################################
# Security Group
################################################################################

output "security_group_arn" {
  description = "Amazon Resource Name (ARN) of the security group"
  value       = try(aws_security_group.public_lb.arn, null)
}

output "security_group_id" {
  description = "ID of the security group"
  value       = try(aws_security_group.public_lb.id, null)
}
