data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.tpl")}"

  vars = {
    tf_cluster_name = "${aws_ecs_cluster.ecs.name}"
    tf_efs_id       = "${aws_efs_file_system.ecs.id}"
    userdata_extra  = "${var.userdata}"
  }
}

resource "aws_launch_template" "ecs" {
  name_prefix   = "ecs-${var.name}-"
  image_id      = "${data.aws_ami.amzn.image_id}"
  instance_type = "${var.instance_type_1}"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.ecs.name}"
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = "${var.instance_volume_size_root}"
    }
  }

  block_device_mappings {
    device_name = "/dev/xvdcz"

    ebs {
      volume_size = "${var.instance_volume_size}"
    }
  }

  vpc_security_group_ids = concat(list(aws_security_group.ecs_nodes.id), var.security_group_ids)

  user_data = "${base64encode(data.template_file.userdata.rendered)}"

  lifecycle {
    create_before_destroy = true
  }
}
