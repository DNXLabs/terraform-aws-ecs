resource "random_string" "rds_apps_password" {
  length  = 34
  special = false
}

resource "aws_rds_cluster" "apps" {
  cluster_identifier      = "${local.workspace["db_name"]}-cluster"
  engine                  = "aurora"
  engine_mode             = "serverless"
  db_subnet_group_name    = local.workspace["db_subnet"]
  vpc_security_group_ids  = [aws_security_group.rds_apps.id]
  master_username         = "master"
  master_password         = random_string.rds_apps_password.result
  backup_retention_period = local.workspace["db_retention"]
  apply_immediately       = true

  scaling_configuration {
    auto_pause               = true
    max_capacity             = 4
    min_capacity             = 2
    seconds_until_auto_pause = 300
  }

  lifecycle {
    ignore_changes = ["master_password"]
  }
}

resource "aws_security_group" "rds_apps" {
  name   = "rds-${local.workspace["cluster_name"]}"
  vpc_id = local.workspace["vpc_id"]

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.ecs_apps.ecs_nodes_secgrp_id]
    description     = "From ECS Nodes"
  }
}

output "rds_host" {
  value = aws_rds_cluster.apps.endpoint
}

output "rds_creds" {
  value = "${aws_rds_cluster.apps.master_username}/${random_string.rds_apps_password.result}"
}
