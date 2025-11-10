terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # 특정 버전 범위 지정
    }
  }
}

# AWS Provider 설정
provider "aws" {
  # RestrictRegionOregon 정책 준수
  region = "us-west-2"
}
