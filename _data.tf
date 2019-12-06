data "aws_region" "current" {}
data "aws_ami" "amzn" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*"]
  }

  name_regex = ".+-amazon-ecs-optimized$"
}

data "aws_caller_identity" "current" {}
data "aws_iam_account_alias" "current" {}

#-------
# KMS
data "aws_kms_key" "ebs" {
  key_id = "alias/aws/ebs"
}
