# VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}_${local.environment}_vpc"
    Environment = local.environment
    Project     = var.project_name
  }
}

# Public Subnet 생성 (단일 AZ: a)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}_${local.environment}_public_subnet"
    Environment = local.environment
    Project     = var.project_name
  }
}

# Internet Gateway 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}_${local.environment}_igw"
    Environment = local.environment
    Project     = var.project_name
  }
}

# Route Table 생성 (Public)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.project_name}_${local.environment}_public_rt"
    Environment = local.environment
    Project     = var.project_name
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private Subnet 생성 (단일 AZ: a)
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}_${local.environment}_private_subnet"
    Environment = local.environment
    Project     = var.project_name
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}_${local.environment}_nat_eip"
    Environment = local.environment
    Project     = var.project_name
  }

  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway 생성 (Public Subnet에 배치)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name        = "${var.project_name}_${local.environment}_nat_gw"
    Environment = local.environment
    Project     = var.project_name
  }

  depends_on = [aws_internet_gateway.igw]
}

# Route Table 생성 (Private)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name        = "${var.project_name}_${local.environment}_private_rt"
    Environment = local.environment
    Project     = var.project_name
  }
}

# Route Table Association (Private)
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}