resource "aws_autoscaling_group" "ecs" {
  name = "ecs-${var.name}"

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = "${aws_launch_template.ecs.id}"
        version            = "$Latest"
      }

      override {
        instance_type = "${var.instance_type_1}"
      }

      override {
        instance_type = "${var.instance_type_2}"
      }

      override {
        instance_type = "${var.instance_type_3}"
      }
    }

    instances_distribution {
      spot_instance_pools                      = 3
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = "${var.on_demand_percentage}"
    }
  }

  vpc_zone_identifier = var.private_subnet_ids

  min_size = "${var.asg_min}"
  max_size = "${var.asg_max}"

  tags = [
    "${map("key", "Name", "value", "ecs-node-${var.name}", "propagate_at_launch", true)}",
  ]

  target_group_arns = var.target_group_arns

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "ecs_memory_tracking" {
  name                      = "ecs-${var.name}-memory"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = "${aws_autoscaling_group.ecs.name}"
  estimated_instance_warmup = "180"

  target_tracking_configuration {
    customized_metric_specification {
      metric_dimension {
        name  = "ClusterName"
        value = "${aws_ecs_cluster.ecs.name}"
      }

      metric_name = "MemoryReservation"
      namespace   = "AWS/ECS"
      statistic   = "Average"
      unit        = "Percent"
    }

    target_value = "${var.asg_memory_target}"
  }
}
