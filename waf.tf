resource "aws_wafv2_web_acl" "waf_alb" {
  count       = var.alb && var.wafv2_enable ? 1 : 0
  name        = "waf-${var.name}-web-application"
  description = "WAF managed rules for web applications v2"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = local.wafv2_rules

    content {
      name     = "waf-${var.name}-${rule.value.type}-${rule.value.name}"
      priority = rule.key

      dynamic "override_action" {
        for_each = rule.value.type == "managed" ? [1] : []
        content {
          count {}
        }
      }

      dynamic "action" {
        for_each = rule.value.type == "rate" ? [1] : []
        content {
          block {}
        }
      }

      statement {
        dynamic "rate_based_statement" {
          for_each = rule.value.type == "rate" ? [1] : []
          content {
            limit              = rule.value.value
            aggregate_key_type = "IP"
          }
        }

        dynamic "managed_rule_group_statement" {
          for_each = rule.value.type == "managed" || rule.value.type == "managed_block" ? [1] : []
          content {
            name        = rule.value.name
            vendor_name = "AWS"
          }
        }
      }


      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "waf-${var.name}-${rule.value.type}-${rule.value.name}"
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

locals {
  wafv2_managed_rule_groups       = [for i, v in var.wafv2_managed_rule_groups : { "name" : v, "type" : "managed" }]
  wafv2_managed_block_rule_groups = [for i, v in var.wafv2_managed_block_rule_groups : { "name" : v, "type" : "managed_block" }]
  wafv2_rate_limit_rule = var.wafv2_rate_limit_rule == 0 ? [] : [{
    "name" : "limit"
    "type" : "rate"
    "value" : var.wafv2_rate_limit_rule
  }]
  wafv2_rules = concat(local.wafv2_rate_limit_rule, local.wafv2_managed_block_rule_groups, local.wafv2_managed_rule_groups)
}

resource "aws_wafv2_web_acl_association" "waf_alb_association" {
  count        = var.alb && var.wafv2_enable ? 1 : 0
  resource_arn = aws_lb.ecs[0].arn
  web_acl_arn  = aws_wafv2_web_acl.waf_alb[0].arn
}