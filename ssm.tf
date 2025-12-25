resource "aws_ssm_parameter" "mongodb_password" {
  name        = "/${var.project_name}/${local.environment}/mongodb/password"
  description = "MongoDB root password"
  type        = "SecureString"
  value       = var.mongodb_password

  tags = {
    Environment = local.environment
    Project     = var.project_name
  }
}

resource "aws_ssm_parameter" "postgres_password" {
  name        = "/${var.project_name}/${local.environment}/postgres/password"
  description = "PostgreSQL master password"
  type        = "SecureString"
  value       = var.postgres_password

  tags = {
    Environment = local.environment
    Project     = var.project_name
  }
}
