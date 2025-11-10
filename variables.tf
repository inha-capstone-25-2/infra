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