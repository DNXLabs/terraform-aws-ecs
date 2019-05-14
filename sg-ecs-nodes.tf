resource "aws_security_group" "ecs_nodes" {
  name        = "ecs-${var.name}-nodes"
  description = "SG for ECS nodes"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name = "ecs-${var.name}-nodes"
  }
}

resource "aws_security_group_rule" "all_from_alb_to_ecs_nodes" {
  count = "${var.alb ? 1 : 0}"

  description              = "from ALB"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.ecs_nodes.id}"
  source_security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "all_from_ecs_nodes_to_ecs_nodes" {
  description              = "Traffic between ECS nodes"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.ecs_nodes.id}"
  source_security_group_id = "${aws_security_group.ecs_nodes.id}"
}

resource "aws_security_group_rule" "all_from_ecs_nodes_world" {
  description       = "Traffic to internet"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.ecs_nodes.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}
