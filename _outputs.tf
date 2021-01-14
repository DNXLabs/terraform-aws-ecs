output "alb_id" {
  value = aws_lb.ecs.*.id
}

output "alb_arn" {
  value = aws_lb.ecs.*.arn
}

output "alb_dns_name" {
  value = aws_lb.ecs.*.dns_name
}

output "alb_zone_id" {
  value = aws_lb.ecs.*.zone_id
}

output "alb_internal_id" {
  value = aws_lb.ecs_internal.*.id
}

output "alb_internal_arn" {
  value = aws_lb.ecs_internal.*.arn
}

output "alb_internal_dns_name" {
  value = aws_lb.ecs_internal.*.dns_name
}

output "alb_internal_zone_id" {
  value = aws_lb.ecs_internal.*.zone_id
}

output "ecs_iam_role_arn" {
  value = aws_iam_role.ecs.arn
}

output "ecs_iam_role_name" {
  value = aws_iam_role.ecs.name
}

output "ecs_service_iam_role_arn" {
  value = aws_iam_role.ecs_service.arn
}

output "ecs_service_iam_role_name" {
  value = aws_iam_role.ecs_service.name
}

output "ecs_task_iam_role_arn" {
  value = aws_iam_role.ecs_task.arn
}

output "ecs_task_iam_role_name" {
  value = aws_iam_role.ecs_task.name
}

output "ecs_id" {
  value = aws_ecs_cluster.ecs.id
}

output "ecs_arn" {
  value = aws_ecs_cluster.ecs.arn
}

output "ecs_name" {
  value = aws_ecs_cluster.ecs.name
}

output "alb_listener_https_arn" {
  value = aws_lb_listener.ecs_https.*.arn
}

output "alb_listener_test_traffic_arn" {
  value = aws_lb_listener.ecs_test_https.*.arn
}

output "alb_internal_listener_https_arn" {
  value = aws_lb_listener.ecs_https_internal.*.arn
}

output "alb_internal_listener_test_traffic_arn" {
  value = aws_lb_listener.ecs_test_https_internal.*.arn
}

output "ecs_nodes_secgrp_id" {
  value = aws_security_group.ecs_nodes.id
}

output "alb_secgrp_id" {
  value = aws_security_group.alb.*.id
}
