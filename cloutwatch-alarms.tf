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

resource "aws_cloudwatch_metric_alarm" "asg_high_cpu" {
  count = length(var.alarm_sns_topics) > 0 && var.alarm_asg_high_cpu_threshold != 0 ? 1 : 0

  alarm_name                = "${data.aws_iam_account_alias.current.account_alias}-ecs-${var.name}-asg-high-cpu"
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
    AutoScalingGroupName = aws_autoscaling_group.ecs.name
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_500_errors" {
  count = var.alb && length(var.alarm_sns_topics) > 0 && var.alarm_alb_500_errors_threshold != 0 ? 1 : 0

  alarm_name                = "${data.aws_iam_account_alias.current.account_alias}-ecs-${var.name}-alb-500-errors"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "HTTPCode_ELB_5XX_Count"
  namespace                 = "AWS/ApplicationELB"
  period                    = "300"
  statistic                 = "Maximum"
  threshold                 = var.alarm_alb_500_errors_threshold
  alarm_description         = "Number of 500 errors at ALB above threshold"
  alarm_actions             = var.alarm_sns_topics
  ok_actions                = var.alarm_sns_topics
  insufficient_data_actions = []
  treat_missing_data        = "ignore"

  dimensions = {
    LoadBalancer = aws_lb.ecs[0].arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_400_errors" {
  count = var.alb && length(var.alarm_sns_topics) > 0 && var.alarm_alb_400_errors_threshold != 0 ? 1 : 0

  alarm_name                = "${data.aws_iam_account_alias.current.account_alias}-ecs-${var.name}-alb-400-errors"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "HTTPCode_ELB_4XX_Count"
  namespace                 = "AWS/ApplicationELB"
  period                    = "300"
  statistic                 = "Maximum"
  threshold                 = var.alarm_alb_400_errors_threshold
  alarm_description         = "Number of 400 errors at ALB above threshold"
  alarm_actions             = var.alarm_sns_topics
  ok_actions                = var.alarm_sns_topics
  insufficient_data_actions = []
  treat_missing_data        = "ignore"

  dimensions = {
    LoadBalancer = aws_lb.ecs[0].arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_latency" {
  count = var.alb && length(var.alarm_sns_topics) > 0 ? 1 : 0
  # alarm_name                = "${data.aws_iam_account_alias.current.account_alias}-ecs-${var.name}-alb-latency"
  alarm_name                = "${data.aws_iam_account_alias.current.account_alias}-ecs-${var.name}-latency"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = "4"
  datapoints_to_alarm       = "2"
  threshold_metric_id       = "ad1"
  alarm_description         = "Load balancer latency for application"
  alarm_actions             = var.alarm_sns_topics
  ok_actions                = var.alarm_sns_topics
  insufficient_data_actions = []
  treat_missing_data        = "ignore"

  metric_query {
    id          = "ad1"
    expression  = "ANOMALY_DETECTION_BAND(m1, ${var.alarm_alb_latency_anomaly_threshold})"
    label       = "TargetResponseTime (Expected)"
    return_data = "true"
  }
  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "TargetResponseTime"
      namespace   = "AWS/ApplicationELB"
      period      = "300"
      stat        = "p99"

      dimensions = {
        LoadBalancer = aws_lb.ecs[0].arn_suffix
      }
    }
  }
}
