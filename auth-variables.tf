# AWS authentication variables | auth-variables.tf
variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "aws_key_name" {
  type        = string
  description = "AWS Key Name"
}