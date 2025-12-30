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

# ===== VPC Endpoints for SSM Session Manager =====

# SSM Endpoint (SSM API, Parameter Store)
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name        = "${var.project_name}_${local.environment}_ssm_endpoint"
    Environment = local.environment
    Project     = var.project_name
  }
}

# SSM Messages Endpoint (Session Manager WebSocket)
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name        = "${var.project_name}_${local.environment}_ssmmessages_endpoint"
    Environment = local.environment
    Project     = var.project_name
  }
}

# EC2 Messages Endpoint (SSM Agent Communication, Run Command)
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name        = "${var.project_name}_${local.environment}_ec2messages_endpoint"
    Environment = local.environment
    Project     = var.project_name
  }
}
