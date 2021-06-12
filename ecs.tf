resource "aws_ecs_cluster" "ecs" {

  depends_on = [aws_autoscaling_group.ecs, aws_ecs_capacity_provider.ecs_capacity_provider]
  name       = var.name

  capacity_providers = ["${var.name}-capacity-provider"]
  default_capacity_provider_strategy {
    capacity_provider = "${var.name}-capacity-provider"
    base              = 0
    weight            = 1
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}
