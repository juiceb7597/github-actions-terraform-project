#########################################
# IAM
#########################################

output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = try(aws_iam_role.ec2_role.arn, "")
}

output "iam_role_name" {
  description = "Name of IAM role"
  value       = try(aws_iam_role.ec2_role.name, "")
}

output "iam_role_path" {
  description = "Path of IAM role"
  value       = try(aws_iam_role.ec2_role.path, "")
}

output "iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = try(aws_iam_role.ec2_role.unique_id, "")
}

output "iam_instance_profile_arn" {
  description = "ARN assigned by AWS to the instance profile"
  value       = try(aws_iam_instance_profile.this.arn, "")
}

output "iam_instance_profile_id" {
  description = "Instance profile's ID"
  value       = try(aws_iam_instance_profile.this.id, "")
}

output "iam_instance_profile_unique" {
  description = "Stable and unique string identifying the IAM instance profile"
  value       = try(aws_iam_instance_profile.this.unique_id, "")
}