resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "main" {
  bucket = "${var.project_name}-${local.environment}-data-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.project_name}-${local.environment}-data"
    Environment = local.environment
    Project     = var.project_name
  }
}
