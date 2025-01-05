resource "aws_cloudwatch_metric_alarm" "asg_high_cpu" {
  count = !var.fargate_only && length(var.alarm_sns_topics) > 0 && var.alarm_asg_high_cpu_threshold != 0 ? 1 : 0

  alarm_name                = "${try(data.aws_iam_account_alias.current[0].account_alias, var.alarm_prefix)}-ecs-${var.name}-asg-high-cpu"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = var.alarm_asg_high_cpu_threshold
  alarm_description         = "ASG CPU above threshold"
  alarm_actions             = var.alarm_sns_topics
  ok_actions                = var.alarm_sns_topics
  insufficient_data_actions = []
  treat_missing_data        = "ignore"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs[0].name
  }

  tags = merge(var.tags, {
    Name = "${try(data.aws_iam_account_alias.current[0].account_alias, var.alarm_prefix)}-ecs-${var.name}-asg-high-cpu"
  })
}
