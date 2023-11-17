terraform {
  backend "s3" {
    bucket         = "github-actions-juiceb"
    key            = "joo/terraform-devops-project/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "terragrunt-lock"
  }
}

module "network" {
  source = "./modules/network"

  name                   = var.name
  tags                   = var.tags
  azs                    = var.azs
  cidr                   = var.cidr
  public_subnet_cidr     = var.public_subnet_cidr
  web_subnet_cidr        = var.web_subnet_cidr
  private_lb_subnet_cidr = var.private_lb_subnet_cidr
  was_subnet_cidr        = var.was_subnet_cidr
  db_subnet_cidr         = var.db_subnet_cidr
}

output "vpc_id" {
  value = module.network.vpc_id
}

module "iam" {
  source = "./modules/iam"

  name = var.name
  tags = var.tags
}

module "public_lb" {
  source = "./modules/public-lb"

  name               = var.name
  tags               = var.tags
  public_lb_subnets  = module.network.public_subnets
  load_balancer_type = var.load_balancer_type
  vpc_id             = module.network.vpc_id
  public_lb_sg_ports = var.public_lb_sg_ports
}

output "lb_sg_id" {
  value = module.public_lb.security_group_id
}

output "vpc_zone_identifier" {
  value = module.network.web_subnets
}

module "web" {
  source = "./modules/web"

  name                      = var.name
  tags                      = var.tags
  instance_type             = var.instance_type
  key_name                  = var.key_name
  iam_instance_profile_arn  = module.iam.iam_instance_profile_arn
  vpc_zone_identifier       = module.network.web_subnets
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  target_group_arns         = module.public_lb.target_groups_arn
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  web_sg_ports              = var.web_sg_ports
  public_lb_sg_id           = module.public_lb.security_group_id
  vpc_id                    = module.network.vpc_id
}

output "web_sg_id" {
  value = module.web.security_group_id
}

module "private_lb" {
  source = "./modules/private-lb"

  name                = var.name
  tags                = var.tags
  private_lb_subnets  = module.network.private_lb_subnets
  load_balancer_type  = var.load_balancer_type
  vpc_id              = module.network.vpc_id
  web_sg_id           = module.web.security_group_id
  private_lb_sg_ports = var.private_lb_sg_ports
}

module "route53" {
  source              = "./modules/route53"
  name                = var.name
  tags                = var.tags
  vpc_id              = module.network.vpc_id
  public_lb_dns_name  = module.public_lb.dns_name
  public_lb_zone_id   = module.public_lb.zone_id
  private_lb_dns_name = module.private_lb.dns_name
  private_lb_zone_id  = module.private_lb.zone_id
}

module "was" {
  source = "./modules/was"

  name                      = var.name
  tags                      = var.tags
  instance_type             = var.instance_type
  key_name                  = var.key_name
  iam_instance_profile_arn  = module.iam.iam_instance_profile_arn
  vpc_zone_identifier       = module.network.web_subnets
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  target_group_arns         = module.private_lb.target_groups_arn
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  was_sg_ports              = var.was_sg_ports
  private_lb_sg_id          = module.private_lb.security_group_id
  vpc_id                    = module.network.vpc_id
}

output "was_sg_id" {
  value = module.was.security_group_id
}

module "db" {
  source            = "./modules/db"
  name              = var.name
  tags              = var.tags
  vpc_id            = module.network.vpc_id
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  multi_az          = var.multi_az
  db_sg_ports       = var.db_sg_ports
  was_sg_id         = module.was.security_group_id
  subnet_ids        = module.network.db_subnets
}

output "db_instance_hosted_zone_id" {
  value = module.db.db_instance_hosted_zone_id
}