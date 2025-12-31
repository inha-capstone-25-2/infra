resource "aws_instance" "es_ec2" {
  ami                    = data.aws_ami.ubuntu2204.id
  instance_type          = var.es_instance_type
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.main.id]
  
  private_ip = local.es_private_ip

  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.es_root_volume_size
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [tags, tags_all, root_block_device]
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  user_data_replace_on_change = true

  depends_on = [aws_instance.mongodb_ec2]

  user_data = join("\n", [
    file("${path.module}/scripts/install_docker.sh"),
    templatefile("${path.module}/scripts/setup_es.tftpl", {
      mongodb_host     = aws_instance.mongodb_ec2.private_ip
      mongodb_username = var.mongodb_username
      environment      = local.environment
      project_name     = var.project_name
      region           = var.region
    })
  ])

  tags = {
    Name        = "${var.project_name}_${local.environment}_es_ec2"
    Environment = local.environment
  }
}
