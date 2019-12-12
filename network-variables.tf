# Network Variables

# AWS Region
variable "aws_region" {
  description = "AWS Region for the VPC"
  default     = "eu-west-1"
}

#AWS AZ
variable "aws_az" {
  description = "AWS AZ"
  default     = "eu-west-1c"
}

#VPC test Variables
variable "aws_vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.1.0.0/16"
}

variable "aws_web_subnet_cidr" {
  description = "CIDR for the Web subnet"
  default     = "10.1.1.0/24"
}

variable "aws_app_subnet_cidr" {
  description = "CIDR for the App subnet"
  default     = "10.1.2.0/24"
}

variable "aws_db_subnet_cidr" {
  description = "CIDR for the DB subnet"
  default     = "10.1.3.0/24"
}