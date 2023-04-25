# environment variables
variable "region" {}
variable "project_name" {}
variable "environment" {}

#vpc variables
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_subnet_app_az1_cidr" {}
variable "private_subnet_app_az2_cidr" {}

# security group variable
variable "ssh_ip" {}
variable "ingress_from_port" {}
variable "ingress_to_port" {}

# launch rds variables
variable "database_snapshot_identifier" {}
variable "database_instance_class" {}
variable "database_instance_identifier" {}
variable "multi_az_deployment" {}

# acm variables
variable "domain_name" {}
variable "alternative_names" {}

# alb variable
variable "target_type" {}

# ecs variable
variable "architecture" {}
variable "container_image" {}

# route 53 variable
variable "record_name" {}

# SNS variable
variable "protocol" {}
variable "endpoint" {}