# VPC CIDR 블록 조회
data "aws_vpc" "capstone_vpc" {
  id = var.vpc_id
}

# 기존 보안 그룹을 Terraform으로 관리
resource "aws_security_group" "capstone_02_sg" {
  name        = "launch-wizard-22"
  description = "launch-wizard-22 created 2025-10-11T10:12:32.320Z"
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

  # MongoDB - VPC 내부 및 같은 보안 그룹 내 접근 허용
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.capstone_vpc.cidr_block]
    self        = true
    description = "MongoDB access from VPC and self"
  }

  # Elasticsearch - VPC 내부 및 같은 보안 그룹 내 접근 허용
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.capstone_vpc.cidr_block]
    self        = true
    description = "Elasticsearch access from VPC and self"
  }

  # PostgreSQL - VPC 내부 및 같은 보안 그룹 내 접근 허용
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.capstone_vpc.cidr_block]
    self        = true
    description = "PostgreSQL access from VPC and self"
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
    group    = "inha-capstone"
    username = "inha-capstone-02"
  }
}