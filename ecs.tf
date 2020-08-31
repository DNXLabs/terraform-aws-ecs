resource "aws_ecs_cluster" "ecs" {
  name = var.name

  tags = merge(
    var.tags,
    {
      "EcsCluster"    = var.name
    },
  )   
}
