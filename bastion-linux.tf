# Create Bastion Elastic IP
resource "aws_eip" "aws-bastion-linux-eip" {
  vpc = true
  tags = {
    Name = "${var.app_name}-${var.app_environment}-bastion-linux-eip"
    Environment = var.app_environment
  }
}

# Get latest Ubuntu 18.04 AMI
data "aws_ami" "ubuntu-18_04" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

# Define the security group for the Bastion
resource "aws_security_group" "aws-bastion-linux-sg"{
  name = "${var.app_name}-${var.app_environment}-bastion-linux-sg"
  description = "Access to Linux Bastion Server"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
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
    Name = "${var.app_name}-${var.app_environment}-bastion-linux-sg"
    Environment = var.app_environment
  }
}

# Create EC2 Instance for linuxdows Bastion Server
resource "aws_instance" "aws-bastion-linux" {
  ami  = data.aws_ami.ubuntu-18_04.id
  instance_type = "t2.micro"
  key_name = var.aws_key_name
  subnet_id = aws_subnet.aws-web-subnet.id
  vpc_security_group_ids = [aws_security_group.aws-bastion-linux-sg.id]
  associate_public_ip_address = true
  source_dest_check = false
  tags = {
    Name = "${var.app_name}-${var.app_environment}-bastion-linux"
    Environment = var.app_environment
  }
}

# Associate Test Bastion Elastic IP
resource "aws_eip_association" "aws-bastion-linux-eip-association" {
  instance_id   = aws_instance.aws-bastion-linux.id
  allocation_id = aws_eip.aws-bastion-linux-eip.id
}