# Initialize the AWS provider
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}

#----VPC & Subnet----

# Create the VPC
resource "aws_vpc" "aws-vpc" {
  cidr_block = var.aws_vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.app_name}-${var.app_environment}-vpc"
    Environment = var.app_environment
  }
}
# Define the web subnet
resource "aws_subnet" "aws-web-subnet" {
  vpc_id = aws_vpc.aws-vpc.id
  cidr_block = var.aws_web_subnet_cidr
  availability_zone = var.aws_az
  tags = {
    Name = "${var.app_name}-${var.app_environment}-web-subnet"
    Environment = var.app_environment
  }
}

# Define the app subnet
resource "aws_subnet" "aws-app-subnet" {
  vpc_id = aws_vpc.aws-vpc.id
  cidr_block = var.aws_app_subnet_cidr
  availability_zone = var.aws_az
  tags = {
    Name = "${var.app_name}-${var.app_environment}-app-subnet"
    Environment = var.app_environment
  }
}

# Define the db subnet
resource "aws_subnet" "aws-db-subnet" {
  vpc_id = aws_vpc.aws-vpc.id
  cidr_block = var.aws_db_subnet_cidr
  availability_zone = var.aws_az
  tags = {
    Name = "${var.app_name}-${var.app_environment}-db-subnet"
    Environment = var.app_environment
  }
}

#----Internet Gateway----

# Define the internet gateway
resource "aws_internet_gateway" "aws-gw" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name = "${var.app_name}-${var.app_environment}-igw"
    Environment = var.app_environment
  }
}

# Define the public route table
resource "aws_route_table" "aws-web-rt" {
  vpc_id = aws_vpc.aws-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-gw.id
  }
  tags = {
    Name = "${var.app_name}-${var.app_environment}-web-route-table"
    Environment = var.app_environment
  }
}

# Assign the public route table to the web subnet
resource "aws_route_table_association" "aws-web-rt-association" {
  subnet_id = aws_subnet.aws-web-subnet.id
  route_table_id = aws_route_table.aws-web-rt.id
}

#----NAT Gateway----

# Create NAT Gateway Elastic IP
resource "aws_eip" "aws-nat-gw-eip" {
  vpc = true
  depends_on = [aws_internet_gateway.aws-gw]
  tags = {
    Name = "${var.app_name}-${var.app_environment}-nat-gateway-eip"
    Environment = var.app_environment
  }
}

# Create NAT gateway
resource "aws_nat_gateway" "aws-nat" {
  allocation_id = aws_eip.aws-nat-gw-eip.id
  subnet_id = aws_subnet.aws-web-subnet.id
  depends_on = [aws_internet_gateway.aws-gw]
  tags = {
    Name = "${var.app_name}-${var.app_environment}-nat-gateway"
    Environment = var.app_environment
  }
}

#----Private Route App Subnet----

# Define the App private route table
resource "aws_route_table" "aws-app-route-table" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name = "${var.app_name}-${var.app_environment}-app-route-table"
    Environment = var.app_environment
  }
}

# Create the App route to the internet
resource "aws_route" "aws-app-route" {
	route_table_id  = aws_route_table.aws-app-route-table.id
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = aws_nat_gateway.aws-nat.id
}

# Assign the App route table to the App Subnet
resource "aws_route_table_association" "aws-app-rt-association" {
  subnet_id = aws_subnet.aws-app-subnet.id
  route_table_id = aws_route_table.aws-app-route-table.id
}

#----Private Route DB Subnet----

# Define the DB private route table
resource "aws_route_table" "aws-db-route-table" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name = "${var.app_name}-${var.app_environment}-db-route-table"
    Environment = var.app_environment
  }
}

# Create the DB route to the internet
resource "aws_route" "aws-db-route" {
	route_table_id  = aws_route_table.aws-db-route-table.id
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = aws_nat_gateway.aws-nat.id
}

# Assign the DB route table to the db Subnet
resource "aws_route_table_association" "aws-db-rt-association" {
  subnet_id = aws_subnet.aws-db-subnet.id
  route_table_id = aws_route_table.aws-db-route-table.id
}