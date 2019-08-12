resource "aws_cloudwatch_metric_alarm" "high_memory" {
  count = "${var.alarm_sns_topic == "" ? 0 : 1}"

  alarm_name                = "ecs-${var.name}-high-memory"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "MemoryUtilization"
  namespace                 = "AWS/ECS"
  period                    = "600"
  statistic                 = "Maximum"
  threshold                 = "80"
  alarm_description         = "Cluster node memory above threshold"
  alarm_actions             = ["${var.alarm_sns_topic}"]

  dimensions = {
    ClusterName = "${aws_ecs_cluster.ecs.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = "${var.alarm_sns_topic == "" ? 0 : 1}"

  alarm_name                = "ecs-${var.name}-high-cpu"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = "600"
  statistic                 = "Maximum"
  threshold                 = "80"
  alarm_description         = "Cluster node CPU above threshold"
  alarm_actions             = ["${var.alarm_sns_topic}"]

  dimensions = {
    ClusterName = "${aws_ecs_cluster.ecs.name}"
  }
}