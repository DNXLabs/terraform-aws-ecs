# terraform-aws-ecs

[![Lint Status](https://github.com/DNXLabs/terraform-aws-ecs/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-ecs/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-ecs)](https://github.com/DNXLabs/terraform-aws-ecs/blob/master/LICENSE)

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

<!--- BEGIN_TF_DOCS --->
<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-ecs/blob/master/LICENSE) for full details.