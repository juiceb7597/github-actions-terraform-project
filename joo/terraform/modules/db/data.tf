data "aws_secretsmanager_secret" "by-name" {
  name = "db-secret"
}
data "aws_secretsmanager_secret_version" "db-secret" {
  secret_id = data.aws_secretsmanager_secret.by-name.id
}