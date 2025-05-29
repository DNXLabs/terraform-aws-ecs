# Example of using path-based routing with multiple services

# First service - WordPress
module "ecs_app_wordpress_01" {
  source                 = "git::https://github.com/DNXLabs/terraform-aws-ecs-app.git?ref=1.5.0"
  vpc_id                 = local.workspace["vpc_id"]
  cluster_name           = module.ecs_apps.ecs_name
  service_role_arn       = module.ecs_apps.ecs_service_iam_role_arn
  task_role_arn          = module.ecs_apps.ecs_task_iam_role_arn
  alb_listener_https_arn = element(module.ecs_apps.alb_listener_https_arn, 0)
  alb_dns_name           = element(module.ecs_apps.alb_dns_name, 0)
  name                   = "wordpress-01"
  image                  = "nginxdemos/hello:latest"
  container_port         = 80
  hostname               = "wp01.labs.dnx.host"
  hostname_blue          = "wp01-blue.labs.dnx.host"
  hostname_origin        = "wp01-origin.labs.dnx.host"
  hosted_zone            = "labs.dnx.host"
  certificate_arn        = local.workspace["cf_certificate_arn"]
  healthcheck_path       = "/readme.html"
  service_health_check_grace_period_seconds = 120
}

# Second service - API
module "ecs_app_api" {
  source                 = "git::https://github.com/DNXLabs/terraform-aws-ecs-app.git?ref=1.5.0"
  vpc_id                 = local.workspace["vpc_id"]
  cluster_name           = module.ecs_apps.ecs_name
  service_role_arn       = module.ecs_apps.ecs_service_iam_role_arn
  task_role_arn          = module.ecs_apps.ecs_task_iam_role_arn
  alb_listener_https_arn = element(module.ecs_apps.alb_listener_https_arn, 0)
  alb_dns_name           = element(module.ecs_apps.alb_dns_name, 0)
  name                   = "api"
  image                  = "nginxdemos/hello:latest"
  container_port         = 80
  hostname               = "api.labs.dnx.host"
  hostname_blue          = "api-blue.labs.dnx.host"
  hostname_origin        = "api-origin.labs.dnx.host"
  hosted_zone            = "labs.dnx.host"
  certificate_arn        = local.workspace["cf_certificate_arn"]
  healthcheck_path       = "/health"
  service_health_check_grace_period_seconds = 120
}

# Configure path-based routing in the ECS cluster module
locals {
  path_based_routing_rules = [
    {
      path_pattern     = "/wordpress/*"
      target_group_arn = module.ecs_app_wordpress_01.target_group_arn
      priority         = 100
    },
    {
      path_pattern     = "/api/*"
      target_group_arn = module.ecs_app_api.target_group_arn
      priority         = 110
    }
  ]
}

# Update the ECS cluster module to use path-based routing
module "ecs_apps" {
  source               = "git::https://github.com/DNXLabs/terraform-aws-ecs.git?ref=0.2.0"
  name                 = local.workspace["cluster_name"]
  instance_type_1      = "t3.large"
  instance_type_2      = "t2.large"
  instance_type_3      = "m2.xlarge"
  vpc_id               = local.workspace["vpc_id"]
  private_subnet_ids   = [split(",", local.workspace["private_subnet_ids"])]
  public_subnet_ids    = [split(",", local.workspace["public_subnet_ids"])]
  secure_subnet_ids    = [split(",", local.workspace["secure_subnet_ids"])]
  certificate_arn      = local.workspace["alb_certificate_arn"]
  on_demand_percentage = 0
  
  # Path-based routing configuration
  alb_listener_rules = local.path_based_routing_rules
}