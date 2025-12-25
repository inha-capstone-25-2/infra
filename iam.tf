data "aws_iam_instance_profile" "safe_profile" {
  name = var.iam_instance_profile_name
}

resource "aws_iam_role_policy_attachment" "ssm_readonly" {
  role       = data.aws_iam_instance_profile.safe_profile.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}
