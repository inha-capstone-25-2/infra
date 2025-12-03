# Elastic IP for Server EC2
resource "aws_eip" "server_eip" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}_${local.environment}_server_eip"
    Environment = local.environment
  }
}

# Elastic IP Association
resource "aws_eip_association" "server_eip_assoc" {
  instance_id   = aws_instance.server_ec2.id
  allocation_id = aws_eip.server_eip.id
}
