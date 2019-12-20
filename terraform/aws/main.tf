// NETWORK
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.network_cidr_block

  azs             = ["eu-west-1a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = var.profile
  }
}

// ECS
module "ecs-fargate" {
  source                       = "cn-terraform/ecs-fargate/aws"
  version                      = 2.0.7
  name_preffix                 = var.prefix
  profile                      = var.profile
  region                       = var.aws_cred["aws_location"]
  vpc_id                       = module.vpc.vgw_id
  availability_zones           = module.vpc.azs

  ecs_cluster_name             = format("%s%s", var.prefix, "FARGATE")
  health_check_path            = var.health_check
  entrypoint                   = var.service_endpoint

  public_subnets_ids           = module.vpc.public_subnets
  private_subnets_ids          = module.vpc.private_subnets
  container_name               = format("%s%s-nginx-reviever", local.prefix, var.profile)
  container_image              = format("%s:%s", "nginx", "latest")
  container_cpu                = 1024
  container_memory             = 1024
  container_memory_reservation = 256
  essential                    = true
  container_port               = var.container_port
  environment = [
    { name  = "Name", value = format("%s%s", local.prefix, "ecs-cluter") },
    { name  = "Env",  value = var.profile }
  ]

  // useless inputs
  ecs_cluster_arn                = ""
  task_definition_arn            = ""
  subnets                        = ""
}

// Application Load Balancer
module "alb" {
  source                        = "terraform-aws-modules/alb/aws"
  load_balancer_name            = "my-alb"
  log_bucket_name               = format("%s%s", local.prefix, "bucket-logs")
  log_location_prefix           = "my-alb-logs"
  subnets                       = module.vpc.public_subnets
  tags                          = map("Environment", var.profile)
  vpc_id                        = module.vpc.vpc_id
  http_tcp_listeners            = list(map("port", "80", "protocol", "HTTP"))
  http_tcp_listeners_count      = "1"
  target_groups                 = list(map("name", "foo", "backend_protocol", "HTTP", "backend_port", "80"))
  target_groups_count           = "1"
}