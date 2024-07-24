resource "aws_iam_role" "codedeploy_service" {
  name = "codedeploy-service-${var.name}-${data.aws_region.current.name}"
  tags = merge(
    var.tags,
    {
      "terraform" = "true"
    },
  )
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codedeploy_service" {
  role       = aws_iam_role.codedeploy_service.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}