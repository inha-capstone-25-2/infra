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


variable "postgres_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "rsrs-root"
}


variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
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

variable "nlp_instance_type" {
  description = "Instance type for NLP EC2"
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
  default     = 100
}

variable "es_root_volume_size" {
  description = "Root EBS size (GB) for Elasticsearch EC2"
  type        = number
  default     = 50
}

variable "nlp_root_volume_size" {
  description = "Root EBS size (GB) for NLP EC2"
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

# 고정 Private IP 주소 (서브넷 범위: 172.31.48.0/20)
variable "server_private_ip" {
  description = "Fixed private IP for Server EC2"
  type        = string
  default     = "172.31.48.10"
}

variable "mongodb_private_ip" {
  description = "Fixed private IP for MongoDB EC2"
  type        = string
  default     = "172.31.48.20"
}

variable "es_private_ip" {
  description = "Fixed private IP for Elasticsearch EC2"
  type        = string
  default     = "172.31.48.30"
}

variable "nlp_private_ip" {
  description = "Fixed private IP for NLP EC2"
  type        = string
  default     = "172.31.48.40"
}

