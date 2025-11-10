resource "aws_instance" "capstone_02_mongodb_ec2" {
  ami                    = data.aws_ami.ubuntu2204.id
  instance_type          = var.mongodb_instance_type
  subnet_id              = data.aws_subnets.in_vpc.ids[0]
  vpc_security_group_ids = [data.aws_security_group.capstone_02_sg.id]

  key_name             = var.key_name
  iam_instance_profile = data.aws_iam_instance_profile.safe_profile.name

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.mongodb_root_volume_size
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [tags, tags_all]
  }

  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/script.mongodb.tftpl", {
    mongodb_username = var.mongodb_username
    mongodb_password = var.mongodb_password
  })

  tags = {
    Name = "capstone_02_mongodb_ec2"
  }
}