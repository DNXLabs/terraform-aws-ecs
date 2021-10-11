resource "aws_security_group" "alb" {
  count = var.alb ? 1 : 0

  name        = "ecs-${var.name}-lb"
  description = "SG for ECS ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs-${var.name}-lb"
  }
}

resource "aws_security_group_rule" "http_from_world_to_alb" {
  count = var.alb && var.alb_http_listener ? 1 : 0

  description       = "HTTP Redirect ECS ALB"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb[0].id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_from_world_to_alb" {
  count = var.alb ? 1 : 0

  description       = "HTTPS ECS ALB"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.alb[0].id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_test_listener_from_world_to_alb" {
  count = var.alb && var.alb_sg_allow_test_listener ? 1 : 0

  description       = "HTTPS ECS ALB Test Listener"
  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  security_group_id = aws_security_group.alb[0].id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "to_ecs_nodes" {
  count = var.alb ? 1 : 0

  description              = "Traffic to ECS Nodes"
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.alb[0].id
  source_security_group_id = aws_security_group.ecs_nodes.id
}

resource "aws_security_group_rule" "https_from_alb_to_world" {
  count = var.alb && var.alb_sg_allow_egress_https_world ? 1 : 0

  description       = "Traffic from ECS Nodes to HTTPS endpoints"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.alb[0].id
  cidr_blocks       = ["0.0.0.0/0"]
}
