resource "aws_cloudformation_stack" "tf_exports" {
  name = "terraform-exports-ecs-${var.name}"

  template_body = templatefile("${path.module}/cf-exports.yml", {
    "name" = var.name,
    "vars" = {
      "AlbId"                 = length(aws_lb.ecs[*].id) > 0 ? element(aws_lb.ecs[*].id, 0) : "undefined",
      "AlbArn"                = length(aws_lb.ecs[*].arn) > 0 ? element(aws_lb.ecs[*].arn, 0) : "undefined",
      "AlbDnsName"            = length(aws_lb.ecs[*].dns_name) > 0 ? element(aws_lb.ecs[*].dns_name, 0) : "undefined",
      "AlbZoneId"             = length(aws_lb.ecs[*].zone_id) > 0 ? element(aws_lb.ecs[*].zone_id, 0) : "undefined",
      "AlbSecgrpId"           = length(aws_security_group.alb[*].id) > 0 ? element(aws_security_group.alb[*].id, 0) : "undefined",
      "EcsIamRoleArn"         = try(aws_iam_role.ecs[0].arn, "undefined"),
      "EcsIamRoleName"        = try(aws_iam_role.ecs[0].name, "undefined"),
      "EcsServiceIamRoleArn"  = aws_iam_role.ecs_service.arn,
      "EcsServiceIamRoleName" = aws_iam_role.ecs_service.name,
      "EcsTaskIamRoleArn"     = aws_iam_role.ecs_task.arn,
      "EcsTaskIamRoleName"    = aws_iam_role.ecs_task.name,
      "EcsId"                 = aws_ecs_cluster.ecs.*.id[0],
      "EcsName"               = aws_ecs_cluster.ecs.*.name[0],
      "EcsArn"                = aws_ecs_cluster.ecs.*.arn[0],
      "AlbListenerHttpsArn"   = length(aws_lb_listener.ecs_https[*].arn) > 0 ? element(aws_lb_listener.ecs_https[*].arn, 0) : "undefined",
      "EcsNodesSecGrpId"      = aws_security_group.ecs_nodes.id,
      "VpcId"                 = var.vpc_id
    }
  })
}