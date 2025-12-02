variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "capstone_02"
}

variable "mongodb_username" {
  description = "MongoDB root username"
  type        = string
  default     = "rsrs-root"
}

variable "mongodb_password" {
  description = "MongoDB root password"
  type        = string
  default     = "KIQu3jebjHNhTEE6mm5tgj2oNjYr7J805k2JLbE0AVo"
  sensitive   = true
}

variable "postgres_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "rsrs-root"
}

variable "postgres_password" {
  description = "PostgreSQL master password"
  type        = string
  default     = "e2XNR0qnZ7kKygC3Sl5zQ2BF2FkHcCr110CaCqulOOlPs"
  sensitive   = true
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "vpc_id" {
  description = "Target VPC ID"
  type        = string
  default     = "vpc-0a8e611b221cddec6"
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
  default     = "sg-08b23a1e6bd2bbd1d"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "capstone-02"
}

variable "iam_instance_profile_name" {
  description = "IAM Instance Profile name"
  type        = string
  default     = "SafeInstanceProfileForUser-inha-capstone-02"
}

variable "server_instance_type" {
  description = "Instance type for server EC2"
  type        = string
  default     = "t3.medium"
}

variable "mongodb_instance_type" {
  description = "Instance type for MongoDB EC2"
  type        = string
  default     = "t3.xlarge"
}

variable "es_instance_type" {
  description = "Instance type for Elasticsearch EC2"
  type        = string
  default     = "t3.xlarge"
}

variable "server_root_volume_size" {
  description = "Root EBS size (GB) for server EC2"
  type        = number
  default     = 30
}

variable "mongodb_root_volume_size" {
  description = "Root EBS size (GB) for MongoDB EC2"
  type        = number
  default     = 30
}

variable "es_root_volume_size" {
  description = "Root EBS size (GB) for Elasticsearch EC2"
  type        = number
  default     = 50
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

variable "dataset_log_path" {
  description = "Dataset sync log file path"
  type        = string
  default     = "/var/log/arxiv_sync.log"
}
