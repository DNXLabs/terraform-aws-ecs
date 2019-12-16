data "aws_route53_zone" "selected" {
  name = var.hosted_zone
}

resource "aws_route53_record" "hostname" {
  count = "${var.alb-only && var.hostname_create ? 1 : 0}"

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.hostname
  type    = "CNAME"
  ttl     = "300"
  records = list(element(aws_lb.ecs.*.dns_name, 0))
}

resource "aws_route53_record" "hostname_blue" {
  count = "${var.alb-only ? 1 : 0}"
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.hostname_blue
  type    = "CNAME"
  ttl     = "300"
  records = list(element(aws_lb.ecs.*.dns_name, 0))
}