# terraform-aws-ecs

This module creates an ECS cluster

## Usage

```hcl
module "ecs_apps" {
  # source               = "git::https://github.com/DNXLabs/terraform-aws-ecs.git?ref=0.1.0"

  name                 = "${local.workspace["cluster_name"]}"
  instance_type_1      = "t3.large"
  instance_type_2      = "t2.large"
  instance_type_3      = "m2.xlarge"
  vpc_id               = "${data.aws_vpc.selected.id}"
  private_subnet_ids   = ["${data.aws_subnet_ids.private.ids}"]
  public_subnet_ids    = ["${data.aws_subnet_ids.public.ids}"]
  secure_subnet_ids    = ["${data.aws_subnet_ids.secure.ids}"]
  certificate_arn      = "${data.aws_acm_certificate.dnx_host.arn}"
  on_demand_percentage = 0
  asg_min              = 1
  asg_max              = 4
  asg_memory_target    = 50
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb | Whether to deploy an ALB or not with the cluster | string | `"true"` | no |
| asg\_max | Max number of instances for autoscaling group | string | `"4"` | no |
| asg\_memory\_target | Target average memory percentage to track for autoscaling | string | `"60"` | no |
| asg\_min | Min number of instances for autoscaling group | string | `"1"` | no |
| certificate\_arn |  | string | n/a | yes |
| instance\_type\_1 | Instance type for ECS workers (first priority) | string | n/a | yes |
| instance\_type\_2 | Instance type for ECS workers (second priority) | string | n/a | yes |
| instance\_type\_3 | Instance type for ECS workers (third priority) | string | n/a | yes |
| name | Name of this ECS cluster | string | n/a | yes |
| on\_demand\_percentage | Percentage of on-demand intances vs spot | string | `"100"` | no |
| private\_subnet\_ids | List of private subnet IDs for ECS instances | list | n/a | yes |
| public\_subnet\_ids | List of public subnet IDs for ECS ALB | list | n/a | yes |
| secure\_subnet\_ids | List of secure subnet IDs for EFS | list | n/a | yes |
| security\_group\_ids | Extra security groups for instances | list | `<list>` | no |
| userdata | Extra commands to pass to userdata | string | `""` | no |
| vpc\_id | VPC ID to deploy the ECS cluster | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| alb\_arn |  |
| alb\_dns\_name |  |
| alb\_id |  |
| alb\_listener\_https\_arn |  |
| alb\_zone\_id |  |
| ecs\_arn |  |
| ecs\_iam\_role\_arn |  |
| ecs\_iam\_role\_name |  |
| ecs\_id |  |
| ecs\_name |  |
| ecs\_nodes\_secgrp\_id |  |
| ecs\_service\_iam\_role\_arn |  |
| ecs\_service\_iam\_role\_name |  |
| ecs\_task\_iam\_role\_arn |  |
| ecs\_task\_iam\_role\_name |  |

## Authors

Module managed by [Allan Denot](https://github.com/adenot).

## License

Apache 2 Licensed. See LICENSE for full details.