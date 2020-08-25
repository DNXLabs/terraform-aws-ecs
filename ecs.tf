resource "aws_ecs_cluster" "ecs" {
  name = var.name

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}
