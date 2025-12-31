module "server_ec2" {
  source = "./modules/ec2"

  name                   = "${var.project_name}_${local.environment}_server_ec2"
  ami                    = data.aws_ami.ubuntu2204.id
  instance_type          = var.server_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.main.id]
  private_ip             = local.server_private_ip
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  root_volume_size = var.server_root_volume_size
  root_volume_type = var.root_volume_type

  user_data = join("\n", [
    file("${path.module}/scripts/install_docker.sh"),
    templatefile("${path.module}/scripts/setup_server.tftpl", {
      environment       = local.environment
      region            = var.region
      project_name      = var.project_name
    })
  ])

  tags = {
    Environment = local.environment
    Project     = var.project_name
  }
}