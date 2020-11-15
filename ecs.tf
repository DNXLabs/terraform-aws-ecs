resource "aws_ecs_cluster" "ecs" {
  name = var.name

  setting {
    name = "containerInsights"
    value = var.container_insights
  }

  tags = merge(
    var.tags,
    {
      "EcsCluster" = var.name
    },
  )
}
