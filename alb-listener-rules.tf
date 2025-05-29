resource "aws_lb_listener_rule" "path_based_routing" {
  count = var.alb ? length(var.alb_listener_rules) : 0

  listener_arn = aws_lb_listener.ecs_https[0].arn
  priority     = var.alb_listener_rules[count.index].priority

  action {
    type             = "forward"
    target_group_arn = var.alb_listener_rules[count.index].target_group_arn
  }

  condition {
    path_pattern {
      values = [var.alb_listener_rules[count.index].path_pattern]
    }
  }

  dynamic "condition" {
    for_each = var.alb_listener_rules[count.index].host_header != null ? [1] : []

    content {
      host_header {
        values = [var.alb_listener_rules[count.index].host_header]
      }
    }
  }

  tags = merge(
    var.tags,
    {
      "Terraform" = true
    },
  )
}

resource "aws_lb_listener_rule" "path_based_routing_test" {
  count = var.alb && var.alb_test_listener ? length(var.alb_listener_rules) : 0

  listener_arn = aws_lb_listener.ecs_test_https[0].arn
  priority     = var.alb_listener_rules[count.index].priority

  action {
    type             = "forward"
    target_group_arn = var.alb_listener_rules[count.index].target_group_arn
  }

  condition {
    path_pattern {
      values = [var.alb_listener_rules[count.index].path_pattern]
    }
  }

  dynamic "condition" {
    for_each = var.alb_listener_rules[count.index].host_header != null ? [1] : []

    content {
      host_header {
        values = [var.alb_listener_rules[count.index].host_header]
      }
    }
  }

  tags = merge(
    var.tags,
    {
      "Terraform" = true
    },
  )
}

resource "aws_lb_listener_rule" "path_based_routing_internal" {
  count = var.alb_internal ? length(var.alb_internal_listener_rules) : 0

  listener_arn = aws_lb_listener.ecs_https_internal[0].arn
  priority     = var.alb_internal_listener_rules[count.index].priority

  action {
    type             = "forward"
    target_group_arn = var.alb_internal_listener_rules[count.index].target_group_arn
  }

  condition {
    path_pattern {
      values = [var.alb_internal_listener_rules[count.index].path_pattern]
    }
  }

  dynamic "condition" {
    for_each = var.alb_internal_listener_rules[count.index].host_header != null ? [1] : []

    content {
      host_header {
        values = [var.alb_internal_listener_rules[count.index].host_header]
      }
    }
  }

  tags = merge(
    var.tags,
    {
      "Terraform" = true
    },
  )
}

resource "aws_lb_listener_rule" "path_based_routing_internal_test" {
  count = var.alb_internal && var.alb_test_listener ? length(var.alb_internal_listener_rules) : 0

  listener_arn = aws_lb_listener.ecs_test_https_internal[0].arn
  priority     = var.alb_internal_listener_rules[count.index].priority

  action {
    type             = "forward"
    target_group_arn = var.alb_internal_listener_rules[count.index].target_group_arn
  }

  condition {
    path_pattern {
      values = [var.alb_internal_listener_rules[count.index].path_pattern]
    }
  }

  dynamic "condition" {
    for_each = var.alb_internal_listener_rules[count.index].host_header != null ? [1] : []

    content {
      host_header {
        values = [var.alb_internal_listener_rules[count.index].host_header]
      }
    }
  }

  tags = merge(
    var.tags,
    {
      "Terraform" = true
    },
  )
}