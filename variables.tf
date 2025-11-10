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

variable "username" {
  description = "Prefix for the S3 bucket name (e.g., username -> username-arxiv)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.username)) && length(var.username) <= 57
    error_message = "username must be lowercase alphanumeric and hyphen, cannot start/end with hyphen, and keep total bucket name <= 63 (username + '-arxiv')."
  }
}