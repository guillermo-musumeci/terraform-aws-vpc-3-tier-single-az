# Deploy a single AZ network for 3-tier application in AWS using Terraform

* Create a single AZ VPC with 3 subnets: web (public), app (private) & database (private)

* Create Internet Gateway, NAT Gateway and routes

* Create segurity groups for VPC and subnets

* Create bastion servers (Linux & Windows) in the web public subnet and security groups

**Files:**

* **auth-variable**s.tf** --> AWS authentication variables

* **bastion-linux.tf**** --> Linux Bastion

* **bastion-windows.tf** --> Linux Windows

* **common-variables.**tf** --> Common variables (app name, environment, etc)

* **network-main.tf** --> Create network components (VPC, Subnets, etc)

* **network-variables.tf** --> Variables for network components

* **security-main.tf** --> Security groups for all subnets

* **terraform.tfvars** --> AWS authentication variables 

Note: remove the bastion-windows.tf and/or the bastion-linux.tf if you don't need access to private subnets
