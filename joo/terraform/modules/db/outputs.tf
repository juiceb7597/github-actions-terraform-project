#########################################
# RDS
#########################################

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = try(aws_db_instance.postgres.address, null)
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = try(aws_db_instance.postgres.arn, null)
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = try(aws_db_instance.postgres.availability_zone, null)
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = try(aws_db_instance.postgres.endpoint, null)
}

output "db_listener_endpoint" {
  description = "Specifies the listener connection endpoint for SQL Server Always On"
  value       = try(aws_db_instance.postgres.listener_endpoint, null)
}

output "db_instance_engine" {
  description = "The database engine"
  value       = try(aws_db_instance.postgres.engine, null)
}

output "db_instance_engine_version_actual" {
  description = "The running version of the database"
  value       = try(aws_db_instance.postgres.engine_version_actual, null)
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = try(aws_db_instance.postgres.hosted_zone_id, null)
}

output "db_instance_identifier" {
  description = "The RDS instance identifier"
  value       = try(aws_db_instance.postgres.identifier, null)
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = try(aws_db_instance.postgres.resource_id, null)
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = try(aws_db_instance.postgres.status, null)
}

output "db_instance_name" {
  description = "The database name"
  value       = try(aws_db_instance.postgres.db_name, null)
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = try(aws_db_instance.postgres.username, null)
  sensitive   = true
}

output "db_instance_port" {
  description = "The database port"
  value       = try(aws_db_instance.postgres.port, null)
}

output "db_instance_ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  value       = try(aws_db_instance.postgres.ca_cert_identifier, null)
}

output "db_instance_domain" {
  description = "The ID of the Directory Service Active Directory domain the instance is joined to"
  value       = try(aws_db_instance.postgres.domain, null)
}

output "db_instance_domain_iam_role_name" {
  description = "The name of the IAM role to be used when making API calls to the Directory Service"
  value       = try(aws_db_instance.postgres.domain_iam_role_name, null)
}


output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = try(aws_db_subnet_group.this.id, null)
}

output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = try(aws_db_subnet_group.this.arn, null)
}