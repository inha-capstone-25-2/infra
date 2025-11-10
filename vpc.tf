data "aws_vpc" "selected" {
  id = "vpc-0a8e611b221cddec6"
}

data "aws_subnets" "in_vpc" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}