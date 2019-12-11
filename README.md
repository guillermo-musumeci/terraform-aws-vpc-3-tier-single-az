# Deploy a single AZ network for 3-tier application in AWS using Terraform

* Create a single AZ VPC with 3 subnets: web (public), app (private) & database (private)

* Create Internet Gateway, NAT Gateway and routes

* Create segurity groups for VPC and subnets

* Create bastion servers (Linux & Windows) in the web public subnet and security groups

Note: remove the bastion-windows.tf and/or the bastion-linux.tf if you don't need access to private subnets
