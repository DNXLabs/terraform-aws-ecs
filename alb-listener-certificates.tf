resource "aws_lb_listener_certificate" "alb" {
  count           = var.alb ? length(var.extra_certificate_arns) : 0
  listener_arn    = element(aws_lb_listener.ecs_https.*.arn, 0)
  certificate_arn = var.extra_certificate_arns[count.index]
}

resource "aws_lb_listener_certificate" "alb_internal" {
  count           = var.alb_internal ? length(var.extra_certificate_arns) : 0
  listener_arn    = element(aws_lb_listener.ecs_https_internal.*.arn, 0)
  certificate_arn = var.extra_certificate_arns[count.index]
}

