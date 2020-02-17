resource "aws_cloudformation_stack" "tf_exports" {
  name = "terraform-exports-ecs-${var.name}"

  template_body = templatefile("${path.module}/cf-exports.yml", {
    "name" = var.name,
    "vars" = {
      "AlbId"                 = aws_lb.ecs.*.id[0],
      "AlbArn"                = aws_lb.ecs.*.arn[0],
      "AlbDnsName"            = aws_lb.ecs.*.dns_name[0],
      "AlbZoneId"             = aws_lb.ecs.*.zone_id[0],
      "AlbSecgrpId"           = aws_security_group.alb.*.id[0]
      "EcsIamRoleArn"         = aws_iam_role.ecs.arn,
      "EcsIamRoleName"        = aws_iam_role.ecs.name,
      "EcsServiceIamRoleArn"  = aws_iam_role.ecs_service.arn,
      "EcsServiceIamRoleName" = aws_iam_role.ecs_service.name,
      "EcsTaskIamRoleArn"     = aws_iam_role.ecs_task.arn,
      "EcsTaskIamRoleName"    = aws_iam_role.ecs_task.name,
      "EcsId"                 = aws_ecs_cluster.ecs.*.id[0],
      "EcsName"               = aws_ecs_cluster.ecs.*.name[0],
      "EcsArn"                = aws_ecs_cluster.ecs.*.arn[0],
      "AlbListenerHttpsArn"   = aws_lb_listener.ecs_https.*.arn[0],
      "EcsNodesSecGrpId"      = aws_security_group.ecs_nodes.id,
      "VpcId"                 = var.vpc_id
    }
  })
}
