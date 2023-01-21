resource "aws_ecs_cluster" "ecs" {
  name = var.name

  capacity_providers = compact([
    try(aws_ecs_capacity_provider.ecs_capacity_provider[0].name, ""),
    "FARGATE",
    "FARGATE_SPOT"
  ])

  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}
