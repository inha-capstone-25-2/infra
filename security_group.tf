# VPC CIDR 블록 조회
data "aws_vpc" "capstone_vpc" {
  id = var.vpc_id
}

# 기존 보안 그룹을 Terraform으로 관리
resource "aws_security_group" "capstone_02_sg" {
  name        = "capstone-02-sg"
  description = "Security group for Capstone project - Managed by Terraform"
  vpc_id      = data.aws_vpc.capstone_vpc.id

  # SSH - PEM 키를 통한 접근
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  # FastAPI
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "FastAPI access"
  }

  # MongoDB - VPC 내부만 접근 가능
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.capstone_vpc.cidr_block]
    description = "MongoDB access from VPC only"
  }

  # Elasticsearch - VPC 내부만 접근 가능
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.capstone_vpc.cidr_block]
    description = "Elasticsearch access from VPC only"
  }

  # PostgreSQL - VPC 내부만 접근 가능
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.capstone_vpc.cidr_block]
    description = "PostgreSQL access from VPC only"
  }

  # 모든 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "capstone-02-sg"
    ManagedBy   = "Terraform"
    Environment = local.environment
  }

  lifecycle {
    # 기존 보안 그룹을 import할 때 충돌 방지
    create_before_destroy = false
  }
}