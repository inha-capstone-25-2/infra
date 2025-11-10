# EC2 전용 Role
data "aws_iam_instance_profile" "safe_profile" {
  name = "SafeInstanceProfileForUser-inha-capstone-02"
}

# VPC
data "aws_vpc" "selected" {
  id = "vpc-0a8e611b221cddec6"
}

# VPC 내 서브넷 목록 조회(첫 번째 서브넷을 사용)
data "aws_subnets" "in_vpc" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

# Ubuntu 22.04 LTS 최신 AMI 조회 (x86_64, EBS, HVM)
data "aws_ami" "ubuntu2204" {
  most_recent = true
  # Canonical의 공식 계정 ID
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_security_group" "capstone_02_sg" {
  id = "sg-08b23a1e6bd2bbd1d"
}

# EC2
resource "aws_instance" "capstone_02_mongodb_ec2" {
  ami                    = data.aws_ami.ubuntu2204.id
  instance_type          = "t3.medium"
  subnet_id              = data.aws_subnets.in_vpc.ids[0]
  vpc_security_group_ids = [data.aws_security_group.capstone_02_sg.id]

  key_name               = "capstone-02"
  iam_instance_profile   = data.aws_iam_instance_profile.safe_profile.name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = true
  }
  
  lifecycle {
    ignore_changes = [tags, tags_all]
  }

  # user_data 변경 시 인스턴스를 교체하도록 설정 (중요)
  user_data_replace_on_change = true

  # 렌더링된 템플릿의 결과를 user_data로 전달
  user_data = templatefile("${path.module}/script.mongodb.tftpl", {
    mongodb_username = var.mongodb_username
    mongodb_password = var.mongodb_password
  })
  
  tags = {
    Name = "capstone_02_mongodb_ec2"
  }
}

resource "aws_instance" "capstone_02_server_ec2" {
  ami                    = data.aws_ami.ubuntu2204.id
  instance_type          = "t3.medium"
  subnet_id              = data.aws_subnets.in_vpc.ids[0] # 필요 시 다른 서브넷으로 변경 가능
  vpc_security_group_ids = [data.aws_security_group.capstone_02_sg.id]

  key_name               = "capstone-02"
  iam_instance_profile   = data.aws_iam_instance_profile.safe_profile.name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = true
  }
  
  lifecycle {
    ignore_changes = [tags, tags_all]
  }

  user_data_replace_on_change = true

  # PostgreSQL 스크립트 템플릿 파일 참조
  user_data = templatefile("${path.module}/script.postgresql.tftpl", {
    postgres_username = var.postgres_username
    postgres_password = var.postgres_password
  })
  
  tags = {
    Name = "capstone_02_server_ec2"
  }
}

output "server_public_ip" {
  description = "Public IP of capstone_02_server_ec2"
  value       = aws_instance.capstone_02_server_ec2.public_ip
}

output "server_public_dns" {
  description = "Public DNS of capstone_02_server_ec2"
  value       = aws_instance.capstone_02_server_ec2.public_dns
}

output "mongodb_public_ip" {
  description = "Public IP of capstone_02_mongodb_ec2"
  value       = aws_instance.capstone_02_mongodb_ec2.public_ip
}

output "mongodb_public_dns" {
  description = "Public DNS of capstone_02_mongodb_ec2"
  value       = aws_instance.capstone_02_mongodb_ec2.public_dns
}