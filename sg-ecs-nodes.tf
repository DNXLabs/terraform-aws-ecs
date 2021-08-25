resource "aws_security_group" "ecs_nodes" {
  name        = "ecs-${var.name}-nodes"
  description = "SG for ECS nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs-${var.name}-nodes"
  }
}

resource "aws_security_group_rule" "all_from_alb_to_ecs_nodes" {
  count = var.alb ? 1 : 0

  description              = "from ALB"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.ecs_nodes.id
  source_security_group_id = aws_security_group.alb[0].id
}

resource "aws_security_group_rule" "all_from_alb_internal_to_ecs_nodes" {
  count = var.alb_internal ? 1 : 0

  description              = "from internal ALB"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.ecs_nodes.id
  source_security_group_id = aws_security_group.alb_internal[0].id
}

resource "aws_security_group_rule" "ssh_from_vpn_to_ecs_nodes" {
  count = var.ec2_key_enabled ? 1 : 0

  description       = "ssh from VPN"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.vpn_cidr
  security_group_id = aws_security_group.ecs_nodes.id
}

resource "aws_security_group_rule" "all_from_ecs_nodes_to_ecs_nodes" {
  description              = "Traffic between ECS nodes"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.ecs_nodes.id
  source_security_group_id = aws_security_group.ecs_nodes.id
}

resource "aws_security_group_rule" "all_from_ecs_nodes_outbound" {
  count             = length(var.security_group_ecs_nodes_outbound_cidrs)
  description       = "Traffic to outbound cidr ${var.security_group_ecs_nodes_outbound_cidrs[count.index]}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ecs_nodes.id
  cidr_blocks       = [var.security_group_ecs_nodes_outbound_cidrs[count.index]]
}

resource "aws_security_group_rule" "all_from_ecs_nodes_outbound_s3" {
  description       = "Traffic to outbound S3"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_nodes.id
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.s3.id]
}
