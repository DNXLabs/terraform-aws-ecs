data "aws_iam_policy_document" "ecs_events" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_partition.current.partition}:log-group:/ecs/events/${var.name}/*"]

    principals {
      identifiers = ["events.amazonaws.com", "delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "ecs_events" {
  policy_document = data.aws_iam_policy_document.ecs_events[0].json
  policy_name     = "capture-ecs-events-${var.name}"
}
