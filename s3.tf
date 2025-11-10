locals {
  username      = "inha-capstone-02"
  snapshot_date = formatdate("YYYYMMDD", timestamp())
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

resource "aws_s3_object" "snapshot_placeholder" {
  bucket       = aws_s3_bucket.arxiv.id
  key          = "snapshots/${local.snapshot_date}/arxiv-metadata-oai-snapshot.json.gz"
  content      = ""
  content_type = "application/gzip"
}

resource "aws_s3_object" "latest_placeholder" {
  bucket       = aws_s3_bucket.arxiv.id
  key          = "latest.json.gz"
  content      = ""
  content_type = "application/gzip"
}

output "arxiv_bucket_name" {
  value       = aws_s3_bucket.arxiv.bucket
  description = "S3 bucket name"
}

output "snapshot_object_key" {
  value       = aws_s3_object.snapshot_placeholder.key
  description = "Created snapshot object key"
}

output "latest_object_key" {
  value       = aws_s3_object.latest_placeholder.key
  description = "Created latest object key"
}