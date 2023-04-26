locals {
  region       = var.region
  project_name = var.project_name
  environment  = var.environment
}

#Create vpc module
module "vpc" {
  source                      = "../Terraform-modules/vpc"
  region                      = local.region
  project_name                = local.project_name
  environment                 = local.environment
  vpc_cidr                    = var.vpc_cidr
  public_subnet_az1_cidr      = var.public_subnet_az1_cidr
  public_subnet_az2_cidr      = var.public_subnet_az2_cidr
  private_subnet_app_az1_cidr = var.private_subnet_app_az1_cidr
  private_subnet_app_az2_cidr = var.private_subnet_app_az2_cidr
}

#create nat-gatways
module "nat_gateway" {
  source                    = "../Terraform-modules/nat-gateway"
  project_name              = local.project_name
  environment               = local.environment
  public_subnet_az1_id      = module.vpc.public_subnet_az1_id
  internet_gateway          = module.vpc.internet_gateway
  public_subnet_az2_id      = module.vpc.public_subnet_az2_id
  vpc_id                    = module.vpc.vpc_id
  private_app_subnet_az1_id = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id = module.vpc.private_app_subnet_az2_id


}

# create security groups
module "security_group" {
  source            = "../Terraform-modules/security-groups"
  project_name      = local.project_name
  environment       = local.environment
  vpc_id            = module.vpc.vpc_id
  ssh_ip            = var.ssh_ip
  ingress_from_port = var.ingress_from_port
  ingress_to_port   = var.ingress_to_port
}

#launch rds instance
module "rds" {
  source                       = "../Terraform-modules/rds"
  project_name                 = local.project_name
  environment                  = local.environment
  private_app_subnet_az1_id    = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id    = module.vpc.private_app_subnet_az2_id
  database_snapshot_identifier = var.database_snapshot_identifier
  database_instance_class      = var.database_instance_class
  availability_zone_1          = module.vpc.availability_zone_1
  database_instance_identifier = var.database_snapshot_identifier
  multi_az_deployment          = var.multi_az_deployment
  database_security_group_id   = module.security_group.database_security_group_id
}

# Request ssl certificate
module "ssl_certificate" {
  source            = "../Terraform-modules/acm"
  domain_name       = var.domain_name
  alternative_names = var.alternative_names
}

# create application load balancer
module "application_load_balancer" {
  source                = "../Terraform-modules/alb"
  project_name          = local.project_name
  environment           = local.environment
  alb_security_group_id = module.security_group.alb_security_group_id
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  target_type           = var.target_type
  vpc_id                = module.vpc.vpc_id
  certificate_arn       = module.ssl_certificate.certificate_arn
}

# create ecs task execution role 
module "ecs_task_execution_role" {
  source       = "../Terraform-modules/iam-role"
  project_name = local.project_name
  environment  = local.environment
}

# create ecs cluster, task definition and service 
module "ecs" {
  source                       = "../Terraform-modules/ecs"
  region                       = local.region
  project_name                 = local.project_name
  environment                  = local.environment
  ecs_task_execution_role_arn  = module.ecs_task_execution_role.ecs_task_execution_role_arn
  architecture                 = var.architecture
  container_image              = var.container_image
  private_app_subnet_az1_id    = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id    = module.vpc.private_app_subnet_az2_id
  app_server_security_group_id = module.security_group.app_server_security_group_id
  alb_target_group_arn         = module.application_load_balancer.alb_target_group_arn
}

# create auto scalling group 
module "ecs_asg" {
  source       = "../Terraform-modules/asg-ecs"
  project_name = local.project_name
  environment  = local.environment
  ecs_service  = module.ecs.ecs_service
}

# create record set in route 53 
module "route_53" {
  source                             = "../Terraform-modules/route-53"
  domain_name                        = module.ssl_certificate.domain_name
  record_name                        = var.record_name
  application_load_balancer_dns_name = module.application_load_balancer.application_load_balancer_dns_name
  application_load_balancer_zone_id  = module.application_load_balancer.application_load_balancer_zone_id
}

# SNS variable
module "sns" {
  source       = "../Terraform-modules/sns"
  project_name = local.project_name
  environment  = local.environment
  protocol     = var.protocol
  endpoint     = var.endpoint
  ecs_cluster  = module.ecs.ecs_cluster
  ecs_service  = module.ecs.ecs_service
}

# Print the website url
output "website_url" {
  value = join("", ["https://", var.record_name, ".", var.domain_name])
}