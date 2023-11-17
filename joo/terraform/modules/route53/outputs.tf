################################################################################
# Route53 Zone
################################################################################

output "route53_zone_zone_id" {
  description = "Zone ID of Private Route53 zone"
  value       = aws_route53_zone.private.zone_id
}

output "route53_zone_zone_arn" {
  description = "Zone ARN of Private Route53 zone"
  value       = aws_route53_zone.private.arn
}

output "route53_zone_name_servers" {
  description = "Name servers of Private Route53 zone"
  value       = aws_route53_zone.private.name_servers
}

output "route53_zone_name" {
  description = "Name of Private Route53 zone"
  value       = aws_route53_zone.private.name
}

################################################################################
# Route53 Record(s)
################################################################################

output "public_lb_route53_record_name" {
  description = "The name of the record"
  value       = aws_route53_record.public_lb.name
}

output "public_lb_route53_record_fqdn" {
  description = "FQDN built using the zone domain and name"
  value       = aws_route53_record.public_lb.fqdn
}

output "private_lb_route53_record_name" {
  description = "The name of the record"
  value       = aws_route53_record.private_lb.name
}

output "private_lb_route53_record_fqdn" {
  description = "FQDN built using the zone domain and name"
  value       = aws_route53_record.private_lb.fqdn
}