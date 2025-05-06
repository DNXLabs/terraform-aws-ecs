resource "aws_ecs_cluster" "ecs" {
  name = var.name

  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }

  tags = merge(var.tags, {
  })
  lifecycle {
    ignore_changes = []

  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs" {
  cluster_name = aws_ecs_cluster.ecs.name

  capacity_providers = compact([
    try(aws_ecs_capacity_provider.ecs_capacity_provider[0].name, ""),
    "FARGATE",
    "FARGATE_SPOT"
  ])
}
