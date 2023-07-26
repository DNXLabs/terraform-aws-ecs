resource "aws_launch_template" "ecs" {
  count         = var.fargate_only ? 0 : 1
  name_prefix   = "ecs-${var.name}-"
  image_id      = data.aws_ami.amzn.image_id
  instance_type = length(var.instance_types) == 0 ? "t2.micro" : var.instance_types[0]

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs[0].name
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.instance_volume_size
      encrypted   = true
      volume_type = var.volume_type
      kms_key_id  = var.ebs_key_arn != "" ? var.ebs_key_arn : null
    }
  }

  vpc_security_group_ids = concat([aws_security_group.ecs_nodes.id], var.security_group_ids)

  user_data = base64encode(templatefile("${path.module}/userdata.tpl", {
    tf_cluster_name = var.name
    tf_efs_id       = aws_efs_file_system.ecs[0].id
    userdata_extra  = var.userdata
  }))

  key_name = var.ec2_key_enabled ? aws_key_pair.generated_key[0].key_name : null

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_private_key" "algorithm" {
  count     = var.ec2_key_enabled ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  count      = var.ec2_key_enabled ? 1 : 0
  key_name   = "${var.name}-key"
  public_key = tls_private_key.algorithm[0].public_key_openssh
}