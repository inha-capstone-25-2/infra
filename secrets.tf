resource "aws_secretsmanager_secret" "kaggle" {
  name        = var.kaggle_secret_name
  description = "Kaggle API credentials (kaggle.json)"
}

resource "aws_secretsmanager_secret_version" "kaggle" {
  secret_id     = aws_secretsmanager_secret.kaggle.id
  secret_string = jsonencode({
    username = var.kaggle_api_username
    key      = var.kaggle_api_key
  })
}

output "kaggle_secret_arn" {
  value       = aws_secretsmanager_secret.kaggle.arn
  description = "ARN of Kaggle credentials secret"
}