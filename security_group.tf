# Security Group 생성
resource "aws_security_group" "main" {
  name        = "${var.project_name}_${local.environment}_sg"
  description = "Allow SSH, Web, and Internal Traffic"
  vpc_id      = aws_vpc.main.id

  # Inbound: SSH (Anywhere - but recommend restricting in production)
  ingress {
    description = "SSH from Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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