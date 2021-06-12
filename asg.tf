resource "aws_autoscaling_group" "ecs" {
  name               = "ecs-${var.name}"
  capacity_rebalance = true

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.ecs.id
        version            = "$Latest"
      }

      dynamic "override" {
        for_each = var.instance_types
        content {
          instance_type = override.value
        }
      }
    }

    instances_distribution {
      on_demand_base_capacity                  = var.on_demand_base_capacity
      on_demand_percentage_above_base_capacity = var.on_demand_percentage
    }
  }

  vpc_zone_identifier = var.private_subnet_ids

  min_size = var.asg_min
  max_size = var.asg_max

  protect_from_scale_in = var.asg_protect_from_scale_in

  tags = [
    map("key", "Name", "value", "ecs-node-${var.name}", "propagate_at_launch", true)
  ]

  target_group_arns         = var.target_group_arns
  health_check_grace_period = var.autoscaling_health_check_grace_period
  default_cooldown          = var.autoscaling_default_cooldown
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "${var.name}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = var.asg_target_capacity
    }
  }
}
