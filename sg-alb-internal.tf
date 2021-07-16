resource "aws_security_group" "alb_internal" {
  count = var.alb_internal ? 1 : 0

  name        = "ecs-${var.name}-lb-internal"
  description = "SG for ECS Internal ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs-${var.name}-lb"
  }
}

resource "aws_security_group_rule" "https_from_world_to_alb_internal" {
  count = var.alb_internal ? 1 : 0

  description       = "HTTPS ECS Internal ALB"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_internal[0].id
  cidr_blocks       = data.aws_subnet.private_subnets[*].cidr_block
}

resource "aws_security_group_rule" "https_test_listener_from_world_to_alb_internal" {
  count = var.alb_internal ? 1 : 0

  description       = "HTTPS ECS Internal ALB Test Listener"
  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_internal[0].id
  cidr_blocks       = data.aws_subnet.private_subnets[*].cidr_block
}


resource "aws_security_group_rule" "from_alb_internal_to_ecs_nodes" {
  count = var.alb_internal ? 1 : 0

  description              = "Traffic to ECS Nodes"
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.alb_internal[0].id
  source_security_group_id = aws_security_group.ecs_nodes.id
}
