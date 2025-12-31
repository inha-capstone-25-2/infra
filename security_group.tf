# --- Base Security Group (Common) ---
resource "aws_security_group" "base" {
  name        = "${var.project_name}_${local.environment}_base_sg"
  description = "Base SG: SSH and Egress"
  vpc_id      = aws_vpc.main.id

  # Inbound: SSH (SSM Session Manager preferred, but allowing from VPC for legacy/debug)
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
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
    Name        = "${var.project_name}_${local.environment}_base_sg"
    Environment = local.environment
    Project     = var.project_name
  }
}

# --- Server Security Group ---
resource "aws_security_group" "server" {
  name        = "${var.project_name}_${local.environment}_server_sg"
  description = "Server SG: HTTP, HTTPS, App"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from Anywhere"
    from_port   = 80
    to_port     = 80
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

  ingress {
    description = "Spring Boot Application"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}_${local.environment}_server_sg"
    Environment = local.environment
    Project     = var.project_name
  }
}

# --- MongoDB Security Group ---
resource "aws_security_group" "mongodb" {
  name        = "${var.project_name}_${local.environment}_mongodb_sg"
  description = "MongoDB SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Internal MongoDB"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  tags = {
    Name        = "${var.project_name}_${local.environment}_mongodb_sg"
    Environment = local.environment
    Project     = var.project_name
  }
}

# --- Elasticsearch Security Group ---
resource "aws_security_group" "es" {
  name        = "${var.project_name}_${local.environment}_es_sg"
  description = "Elasticsearch SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Internal Elasticsearch HTTP"
    from_port   = 9200
    to_port     = 9200
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

  tags = {
    Name        = "${var.project_name}_${local.environment}_es_sg"
    Environment = local.environment
    Project     = var.project_name
  }
}

# --- NLP Security Group ---
resource "aws_security_group" "nlp" {
  name        = "${var.project_name}_${local.environment}_nlp_sg"
  description = "NLP SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Internal NLP API"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  tags = {
    Name        = "${var.project_name}_${local.environment}_nlp_sg"
    Environment = local.environment
    Project     = var.project_name
  }
}

# --- Monitoring Security Group ---
resource "aws_security_group" "monitoring" {
  name        = "${var.project_name}_${local.environment}_monitoring_sg"
  description = "Monitoring SG: Prometheus & Grafana"
  vpc_id      = aws_vpc.main.id

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

  tags = {
    Name        = "${var.project_name}_${local.environment}_monitoring_sg"
    Environment = local.environment
    Project     = var.project_name
  }
}

# --- VPC Endpoints Security Group ---
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

# --- RDS Security Group ---
resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}_${local.environment}_rds_sg"
  description = "Security group for RDS MySQL"
  vpc_id      = aws_vpc.main.id

  # Inbound: MySQL from Server SG
  ingress {
    description     = "MySQL from Server EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.server.id]
  }

  tags = {
    Name        = "${var.project_name}_${local.environment}_rds_sg"
    Environment = local.environment
    Project     = var.project_name
  }
}