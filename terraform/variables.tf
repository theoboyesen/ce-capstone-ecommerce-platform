variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "theo-capstone-123"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}