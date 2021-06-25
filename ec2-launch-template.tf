data "template_file" "userdata" {
  count    = var.fargate_only ? 0 : 1
  template = file("${path.module}/userdata.tpl")

  vars = {
    tf_cluster_name = var.name
    tf_efs_id       = aws_efs_file_system.ecs[0].id
    userdata_extra  = var.userdata
  }
}

resource "aws_launch_template" "ecs" {
  count         = var.fargate_only ? 0 : 1
  name_prefix   = "ecs-${var.name}-"
  image_id      = data.aws_ami.amzn.image_id
  instance_type = var.instance_types[0]

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs[0].name
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.instance_volume_size
      encrypted   = true
      kms_key_id  = var.kms_key_arn != "" ? var.kms_key_arn : null
    }
  }

  vpc_security_group_ids = concat([aws_security_group.ecs_nodes.id], var.security_group_ids)

  user_data = base64encode(data.template_file.userdata[0].rendered)

  lifecycle {
    create_before_destroy = true
  }
}
