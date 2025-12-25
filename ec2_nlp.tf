resource "aws_instance" "nlp_ec2" {
  ami                    = data.aws_ami.ubuntu2204.id
  instance_type          = var.nlp_instance_type
  subnet_id              = data.aws_subnets.in_vpc.ids[0]
  vpc_security_group_ids = [data.aws_security_group.capstone_02_sg.id]

  private_ip = var.nlp_private_ip

  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.nlp_root_volume_size
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [tags, tags_all, root_block_device]
  }

  tags = {
    Name        = "${var.project_name}_${local.environment}_nlp_ec2"
    Environment = local.environment
  }
}
