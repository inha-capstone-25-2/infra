resource "aws_instance" "capstone_02_server_ec2" {
  ami                    = data.aws_ami.ubuntu2204.id
  instance_type          = "t3.medium"
  subnet_id              = data.aws_subnets.in_vpc.ids[0]
  vpc_security_group_ids = [data.aws_security_group.capstone_02_sg.id]

  key_name             = "capstone-02"
  iam_instance_profile = data.aws_iam_instance_profile.safe_profile.name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [tags, tags_all]
  }

  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/script.postgres.tftpl", {
    postgres_username = var.postgres_username
    postgres_password = var.postgres_password
  })

  tags = {
    Name = "capstone_02_server_ec2"
  }
}