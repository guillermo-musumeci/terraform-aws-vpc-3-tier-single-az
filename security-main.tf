# Define the security group for Web subnet
resource "aws_security_group" "aws-web-sg" {
  name        = "${var.app_name}-${var.app_environment}-web-sg"
  description = "Access to Public Web Subnet"

  # http protocol
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # https protocol
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "${var.app_name}-${var.app_environment}-web-sg"
    Environment = var.app_environment
  }
}

#----------------------------------------

#Define the App security group
resource "aws_security_group" "aws-app-sg" {
  name        = "${var.app_name}-${var.app_environment}-app-sg"
  description = "Access to App Subnet"

  # SSH access from bastion
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.aws_web_subnet_cidr]
  }

  # RDP access from bastion
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.aws_web_subnet_cidr]
  }

  # HTTP access from web public subnet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.aws_web_subnet_cidr]
  }

  # HTTPS access from web public subnet
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.aws_web_subnet_cidr]
  }

  # access from app private subnet
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.aws_app_subnet_cidr]
  }

  # access from db private subnet
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.aws_db_subnet_cidr]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "${var.app_name}-${var.app_environment}-app-sg"
    Environment = var.app_environment
  }
}

#----------------------------------------

#Define the DB security group
resource "aws_security_group" "aws-db-sg" {
  name        = "${var.app_name}-${var.app_environment}-db-sg"
  description = "Access to Database Subnet"

  # SSH access from bastion
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.aws_web_subnet_cidr]
  }

  # RDP access from bastion
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.aws_web_subnet_cidr]
  }

  # access from app private subnet
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.aws_app_subnet_cidr]
  }

  # access from db private subnet
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.aws_db_subnet_cidr]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "${var.app_name}-${var.app_environment}-db-sg"
    Environment = var.app_environment
  }
}
