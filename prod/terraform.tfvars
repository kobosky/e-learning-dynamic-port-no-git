region       = "eu-west-2"
project_name = "e-learning"
environment  = "prod"

# vpc variables
vpc_cidr                     = "10.0.0.0/16"
public_subnet_az1_cidr       = "10.0.1.0/24"
public_subnet_az2_cidr       = "10.0.2.0/24"
private_subnet_app_az1_cidr  = "10.0.3.0/24"
private_subnet_app_az2_cidr  = "10.0.4.0/24"

# security group variable (IP of EC2 from security groups gotten from security group outbound rules)
ssh_ip = "84.71.49.4/32"
ingress_from_port = "443"
ingress_to_port = "443"

# rds variables (snapshot was created in aws = "rentall-ecs-final-snapshot" and "development-levelup-rds")
database_snapshot_identifier = "e-learningdb-snapshot"
database_instance_class      = "db.t2.micro"
database_instance_identifier = "e-learningdb"
multi_az_deployment          = "false"

#acm variables
domain_name       = "kobosky.com"
alternative_names = "*.kobosky.com"

# alb variables
target_type = "ip"

# ecs variable ******if you built your image on windows use X86_64 ******* if you use LINUX use ARM64
architecture    = "X86_64"
container_image = "562834173446.dkr.ecr.eu-west-2.amazonaws.com/my-nginx-image:latest"

# route 53 variable
record_name = "www"

# SNS variable
protocol     = "email"
endpoint     = "ikechukwuaniagolu@yahoo.com"