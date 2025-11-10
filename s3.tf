locals {
  username = "inha-capstone-02"
}

resource "aws_s3_bucket" "arxiv" {
  bucket = "${local.username}-arxiv"

  tags = {
    Name  = "${local.username}-arxiv"
    Owner = local.username
  }
}

resource "aws_s3_bucket_public_access_block" "arxiv" {
  bucket                  = aws_s3_bucket.arxiv.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

output "arxiv_bucket_name" {
  value       = aws_s3_bucket.arxiv.bucket
  description = "S3 bucket name"
}