resource "random_password" "mongodb_password" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "mongodb_password" {
  name        = "/${var.project_name}/${local.environment}/mongodb/password"
  description = "MongoDB root password"
  type        = "SecureString"
  value       = random_password.mongodb_password.result

  tags = {
    Environment = local.environment
    Project     = var.project_name
  }
}

resource "random_password" "postgres_password" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "postgres_password" {
  name        = "/${var.project_name}/${local.environment}/postgres/password"
  description = "PostgreSQL master password"
  type        = "SecureString"
  value       = random_password.postgres_password.result

  tags = {
    Environment = local.environment
    Project     = var.project_name
  }
}
