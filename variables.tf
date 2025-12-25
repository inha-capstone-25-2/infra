

// Project Configuration
variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "capstone_02"
}

// Database Credentials
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


// AWS Configuration
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
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

// Compute Configuration
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

// Storage Configuration
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





