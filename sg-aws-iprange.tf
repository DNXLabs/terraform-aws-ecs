data "aws_ip_ranges" "cloudfront" {
  services = ["cloudfront"]
}

data "aws_ip_ranges" "api_gateway" {
  services = ["api_gateway"]
}

resource "aws_security_group" "from_cloudfront" {
  count = var.alb && var.alb_sg_allow_cloudfront ? 1 : 0
  name = "from-cloudfront-${var.name}"
  description = "SG for Request from Cloudfront"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = "443"
    to_port          = "443"
    protocol         = "tcp"
    cidr_blocks      = data.aws_ip_ranges.cloudfront.cidr_blocks
  }

  tags = {
    Name = "from-cloudfront-${var.name}"
    CreateDate = data.aws_ip_ranges.cloudfront.create_date
    SyncToken  = data.aws_ip_ranges.cloudfront.sync_token
  }
}

resource "aws_security_group" "from_api_gateway" {
  count = var.alb && var.alb_sg_allow_api_gateway ? 1 : 0
  name = "from-api-gateway-${var.name}"
  description = "SG for Request from API Gateway"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = "443"
    to_port          = "443"
    protocol         = "tcp"
    cidr_blocks      = data.aws_ip_ranges.api_gateway.cidr_blocks
  }

  tags = {
    Name = "from-api-gateway-${var.name}"
    CreateDate = data.aws_ip_ranges.api_gateway.create_date
    SyncToken  = data.aws_ip_ranges.api_gateway.sync_token
  }
}