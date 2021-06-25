resource "aws_iam_service_linked_role" "ecs" {
  count            = var.create_iam_service_linked_role ? 1 : 0
  aws_service_name = "ecs.amazonaws.com"
}

resource "aws_iam_instance_profile" "ecs" {
  count = var.fargate_only ? 0 : 1
  name  = "ecs-${var.name}-${data.aws_region.current.name}"
  role  = aws_iam_role.ecs[0].name
}

resource "aws_iam_role" "ecs" {
  count = var.fargate_only ? 0 : 1
  name  = "ecs-${var.name}-${data.aws_region.current.name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_ssm" {
  count      = var.fargate_only ? 0 : 1
  role       = aws_iam_role.ecs[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "ecs_ecs" {
  count      = var.fargate_only ? 0 : 1
  role       = aws_iam_role.ecs[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
