# Security Group 생성
resource "aws_security_group" "main" {
  name        = "${var.project_name}_${local.environment}_sg"
  description = "Allow SSH, Web, and Internal Traffic"
  vpc_id      = aws_vpc.main.id

  # Inbound: SSH (VPC 내부에서만 허용 - SSM Session Manager 사용)
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  # Inbound: HTTP/HTTPS
  ingress {
    description = "HTTP from Anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Spring Boot Application"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from Anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound: Internal Communication (Postgres, MongoDB, Elasticsearch, NLP)
  ingress {
    description = "Internal Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "Internal MongoDB"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "Internal Elasticsearch"
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "Internal NLP API"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  
  ingress {
      description = "Internal Elasticsearch Node Communication"
      from_port   = 9300
      to_port     = 9300
      protocol    = "tcp"
      cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
      description = "Internal Grafana"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
      description = "Internal Prometheus"
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = [aws_vpc.main.cidr_block]
  }

  # Outbound: All Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}_${local.environment}_sg"
    Environment = local.environment
    Project     = var.project_name
  }
}

# VPC Endpoints용 Security Group
resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.project_name}_${local.environment}_vpce_sg"
  description = "Security group for VPC Endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}_${local.environment}_vpce_sg"
    Environment = local.environment
    Project     = var.project_name
  }
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}_${local.environment}_rds_sg"
  description = "Security group for RDS MySQL"
  vpc_id      = aws_vpc.main.id

  # Inbound: MySQL from Server EC2
  ingress {
    description     = "MySQL from Server EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.main.id]
  }

  tags = {
    Name        = "${var.project_name}_${local.environment}_rds_sg"
    Environment = local.environment
    Project     = var.project_name
  }
}