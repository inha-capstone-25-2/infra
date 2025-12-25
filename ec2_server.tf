resource "aws_instance" "server_ec2" {
  ami                    = data.aws_ami.ubuntu2204.id
  instance_type          = var.server_instance_type
  subnet_id              = data.aws_subnets.in_vpc.ids[0]
  vpc_security_group_ids = [data.aws_security_group.capstone_02_sg.id]

  private_ip = var.server_private_ip

  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.server_root_volume_size
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [tags, tags_all, root_block_device]
  }

  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/script.server.tftpl", {
    postgres_username = var.postgres_username
    environment       = local.environment
    region            = var.region
    project_name      = var.project_name
  })

  tags = {
    Name        = "${var.project_name}_${local.environment}_server_ec2"
    Environment = local.environment
  }
}