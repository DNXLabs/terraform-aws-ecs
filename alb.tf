resource "aws_lb" "ecs" {
  count = "${var.alb ? 1 : 0}"

  load_balancer_type = "application"
  internal           = false
  name               = "ecs-${var.name}"
  subnets            = ["${var.public_subnet_ids}"]

  security_groups = [
    "${aws_security_group.alb.id}",
  ]

  idle_timeout = 400

  tags = {
    Name = "ecs-${var.name}"
  }
}

resource "aws_lb_listener" "ecs_https" {
  count = "${var.alb ? 1 : 0}"

  load_balancer_arn = "${aws_lb.ecs.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.certificate_arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.ecs_default_https.arn}"
  }
}

resource "aws_lb_listener" "ecs_http_redirect" {
  count = "${var.alb ? 1 : 0}"

  load_balancer_arn = "${aws_lb.ecs.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "ecs_default_http" {
  count = "${var.alb ? 1 : 0}"

  name     = "ecs-${var.name}-default-http"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_target_group" "ecs_default_https" {
  count = "${var.alb ? 1 : 0}"

  name     = "ecs-${var.name}-default-https"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}
