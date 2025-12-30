# RDS Subnet Group
resource "aws_db_subnet_group" "default" {
  name       = "${var.project_name}-rds-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private_c.id]

  tags = {
    Name        = "${var.project_name}-rds-subnet-group"
    Environment = local.environment
    Project     = var.project_name
  }
}

# RDS Instance (MySQL)
resource "aws_db_instance" "default" {
  identifier        = replace("${var.project_name}-${local.environment}-mysql", "_", "-")
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "capstone"
  username = "admin" # Initial username, will be managed/overridden or just used as root
  password = random_password.rds_password.result

  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name        = "${var.project_name}-${local.environment}-mysql"
    Environment = local.environment
    Project     = var.project_name
  }
}
