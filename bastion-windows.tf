# Create Bastion Elastic IP
resource "aws_eip" "aws-bastion-win-eip" {
  vpc = true
  tags = {
    Name        = "${var.app_name}-${var.app_environment}-bastion-win-eip"
    Environment = var.app_environment
  }
}

# Get latest Windows Server 2019 AMI
data "aws_ami" "windows-2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}

# Define the security group for the Bastion
resource "aws_security_group" "aws-bastion-win-sg" {
  name        = "${var.app_name}-${var.app_environment}-bastion-win-sg"
  description = "Access to Windows Bastion Server"

  ingress {
    from_port   = 3389
    to_port     = 3389
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
    Name        = "${var.app_name}-${var.app_environment}-bastion-win-sg"
    Environment = var.app_environment
  }
}

# Create EC2 Instance for Windows Bastion Server
resource "aws_instance" "aws-bastion-win" {
  ami                         = data.aws_ami.windows-2019.id
  instance_type               = "t2.micro"
  key_name                    = var.aws_key_name
  subnet_id                   = aws_subnet.aws-web-subnet.id
  vpc_security_group_ids      = [aws_security_group.aws-bastion-win-sg.id]
  associate_public_ip_address = true
  source_dest_check           = false
  tags = {
    Name        = "${var.app_name}-${var.app_environment}-bastion-win"
    Environment = var.app_environment
  }
}

# Associate Test Bastion Elastic IP
resource "aws_eip_association" "aws-bastion-win-eip-association" {
  instance_id   = aws_instance.aws-bastion-win.id
  allocation_id = aws_eip.aws-bastion-win-eip.id
}