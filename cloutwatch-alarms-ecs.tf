resource "aws_cloudwatch_metric_alarm" "ecs_high_memory" {
  count = length(var.alarm_sns_topics) > 0 && var.alarm_ecs_high_cpu_threshold != 0 ? 1 : 0

  alarm_name                = "${data.aws_iam_account_alias.current.account_alias}-ecs-${var.name}-high-memory"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "MemoryUtilization"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = var.alarm_ecs_high_memory_threshold
  alarm_description         = "Cluster memory above threshold"
  alarm_actions             = var.alarm_sns_topics
  ok_actions                = var.alarm_sns_topics
  insufficient_data_actions = []
  treat_missing_data        = "ignore"

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs.name
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_high_cpu" {
  count = length(var.alarm_sns_topics) > 0 && var.alarm_ecs_high_cpu_threshold != 0 ? 1 : 0

  alarm_name                = "${data.aws_iam_account_alias.current.account_alias}-ecs-${var.name}-high-cpu"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = var.alarm_ecs_high_cpu_threshold
  alarm_description         = "Cluster CPU above threshold"
  alarm_actions             = var.alarm_sns_topics
  ok_actions                = var.alarm_sns_topics
  insufficient_data_actions = []
  treat_missing_data        = "ignore"

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs.name
  }
}
