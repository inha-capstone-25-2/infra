resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  private_ip             = var.private_ip
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = true
  }

  user_data                   = var.user_data
  user_data_replace_on_change = var.user_data != null ? true : false

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  lifecycle {
    ignore_changes = [tags, tags_all]
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}
