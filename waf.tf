resource "aws_wafv2_web_acl" "alb" {
  count       = var.alb && var.wafv2_enable ? 1 : 0
  name        = "waf-${var.name}-web-application"
  description = "WAF managed rules for web applications"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = var.wafv2_managed_rule_groups

    content {
      name     = "waf-${var.name}-${rule.value}"
      priority = rule.key

      override_action {
        count {}
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "waf-${var.name}-${rule.value}"
        sampled_requests_enabled   = false
      }
    }
  }

  tags = {
    Name = "waf-${var.name}-web-application"
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-${var.name}-general"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "brighte_waf_alb" {
  count        = var.alb && var.wafv2_enable ? 1 : 0
  resource_arn = aws_lb.ecs[0].arn
  web_acl_arn  = aws_wafv2_web_acl.alb[0].arn
}