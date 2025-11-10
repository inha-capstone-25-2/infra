data "aws_iam_instance_profile" "safe_profile" {
  name = var.iam_instance_profile_name
}