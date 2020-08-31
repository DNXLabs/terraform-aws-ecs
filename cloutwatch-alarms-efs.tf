resource "aws_cloudwatch_metric_alarm" "efs_credits_low" {
  count = length(var.alarm_sns_topics) > 0 && var.alarm_efs_credits_low_threshold != 0 ? 1 : 0

  alarm_name                = "${data.aws_iam_account_alias.current.account_alias}-ecs-${var.name}-efs-credits-low"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "BurstCreditBalance"
  namespace                 = "AWS/EFS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = var.alarm_efs_credits_low_threshold
  alarm_description         = "EFS credits below threshold"
  alarm_actions             = var.alarm_sns_topics
  ok_actions                = var.alarm_sns_topics
  insufficient_data_actions = []
  treat_missing_data        = "ignore"

  dimensions = {
    FileSystemId = aws_efs_file_system.ecs.id
  }

  tags = merge(
    var.tags,
    {
      "EcsCluster" = var.name
    },
  )
}
