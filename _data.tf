data "aws_region" "current" {}
data "aws_ami" "amzn" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm*"]
  }

  filter {
    name   = "architecture"
    values = [var.architecture]
  }

  name_regex = ".+-ebs$"
}

data "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_ids)
  id    = var.private_subnet_ids[count.index]
}

data "aws_caller_identity" "current" {}
data "aws_iam_account_alias" "current" {
  count = var.alarm_prefix == "" ? 1 : 0
}

#-------
# KMS
data "aws_kms_key" "ebs" {
  key_id = "alias/aws/ebs"
}

data "aws_kms_key" "efs" {
  key_id = "alias/aws/elasticfilesystem"
}

data "aws_ec2_managed_prefix_list" "s3" {
  name = "com.amazonaws.${data.aws_region.current.name}.s3"
}
