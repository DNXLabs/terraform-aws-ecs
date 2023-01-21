# terraform-aws-ecs

[![Lint Status](https://github.com/DNXLabs/terraform-aws-ecs/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-ecs/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-ecs)](https://github.com/DNXLabs/terraform-aws-ecs/blob/master/LICENSE)

This terraform module builds an Elastic Container Service(ECS) Cluster in AWS.

The following resources will be created:
- Elastic File System (EFS)
- Auto Scaling
- CloudWatch alarms for (Application Load Balancer ,Auto Scale,ECS and EFS)
- S3 Bucket to store logs from the application Load Balancer access
- Security groups for (ALB,ALB-INTERNAL,ECS NODES, RDS DB)
- Web Application Firewall (WAF)
- Instances for ECS Workers
- IAM roles and policies for the container instances

In addition you have the option to create or not :
 - Application Load Balancer (ALB)
     - alb - An external ALB
     - alb_internal - A second internal ALB for private APIs
     - alb_only - Deploy only an Application Load Balancer and no cloudFront or not with the cluster

## Usage

```hcl
module "ecs_apps" {
  # source               = "git::https://github.com/DNXLabs/terraform-aws-ecs.git?ref=0.1.0"

  name                 = "${local.workspace["cluster_name"]}"
  intance_types        = ["t3.large","t2.large","m2.xlarge"]
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

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |
| template | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alarm\_alb\_400\_errors\_threshold | Max threshold of HTTP 4000 errors allowed in a 5 minutes interval (use 0 to disable this alarm). | `number` | `10` | no |
| alarm\_alb\_500\_errors\_threshold | Max threshold of HTTP 500 errors allowed in a 5 minutes interval (use 0 to disable this alarm). | `number` | `10` | no |
| alarm\_alb\_latency\_anomaly\_threshold | ALB Latency anomaly detection width (use 0 to disable this alarm). | `number` | `2` | no |
| alarm\_asg\_high\_cpu\_threshold | Max threshold average CPU percentage allowed in a 2 minutes interval (use 0 to disable this alarm). | `number` | `80` | no |
| alarm\_ecs\_high\_cpu\_threshold | Max threshold average CPU percentage allowed in a 2 minutes interval (use 0 to disable this alarm). | `number` | `80` | no |
| alarm\_ecs\_high\_memory\_threshold | Max threshold average Memory percentage allowed in a 2 minutes interval (use 0 to disable this alarm). | `number` | `80` | no |
| alarm\_efs\_credits\_low\_threshold | Alerts when EFS credits fell below this number in bytes - default 1000000000000 is 1TB of a maximum of 2.31T of credits (use 0 to disable this alarm). | `number` | `1000000000000` | no |
| alarm\_prefix | String prefix for cloudwatch alarms. (Optional) | `string` | `"alarm"` | no |
| alarm\_sns\_topics | Alarm topics to create and alert on ECS instance metrics. | `list` | `[]` | no |
| alb | Whether to deploy an ALB or not with the cluster. | `bool` | `true` | no |
| alb\_drop\_invalid\_header\_fields | Indicates whether HTTP headers with invalid header fields are removed by the load balancer (true) or routed to targets (false). | `bool` | `true` | no |
| alb\_enable\_deletion\_protection | Enable deletion protection for ALBs | `bool` | `false` | no |
| alb\_http\_listener | Whether to enable HTTP listeners | `bool` | `true` | no |
| alb\_internal | Deploys a second internal ALB for private APIs. | `bool` | `false` | no |
| alb\_internal\_ssl\_policy | The name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS. | `string` | `"ELBSecurityPolicy-TLS-1-2-Ext-2018-06"` | no |
| alb\_only | Whether to deploy only an alb and no cloudFront or not with the cluster. | `bool` | `false` | no |
| alb\_sg\_allow\_egress\_https\_world | Whether to allow ALB to access HTTPS endpoints - needed when using OIDC authentication | `bool` | `true` | no |
| alb\_sg\_allow\_test\_listener | Whether to allow world access to the test listeners | `bool` | `true` | no |
| alb\_ssl\_policy | The name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS. | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| architecture | Architecture to select the AMI, x86\_64 or arm64 | `string` | `"x86_64"` | no |
| asg\_capacity\_rebalance | Indicates whether capacity rebalance is enabled | `bool` | `false` | no |
| asg\_max | Max number of instances for autoscaling group. | `number` | `4` | no |
| asg\_min | Min number of instances for autoscaling group. | `number` | `1` | no |
| asg\_protect\_from\_scale\_in | (Optional) Allows setting instance protection. The autoscaling group will not select instances with this setting for termination during scale in events. | `bool` | `false` | no |
| asg\_target\_capacity | Target average capacity percentage for the ECS capacity provider to track for autoscaling. | `number` | `70` | no |
| autoscaling\_default\_cooldown | The amount of time, in seconds, after a scaling activity completes before another scaling activity can start. | `number` | `300` | no |
| autoscaling\_health\_check\_grace\_period | The length of time that Auto Scaling waits before checking an instance's health status. The grace period begins when an instance comes into service. | `number` | `300` | no |
| backup | Assing a backup tag to efs resource - Backup will be performed by AWS Backup. | `string` | `"true"` | no |
| certificate\_arn | n/a | `any` | n/a | yes |
| certificate\_internal\_arn | certificate arn for internal ALB. | `string` | `""` | no |
| container\_insights | Enables CloudWatch Container Insights for a cluster. | `bool` | `false` | no |
| create\_efs | Enables creation of EFS volume for cluster | `bool` | `true` | no |
| create\_iam\_service\_linked\_role | Create iam\_service\_linked\_role for ECS or not. | `bool` | `false` | no |
| ebs\_key\_arn | ARN of a KMS Key to use on EBS volumes | `string` | `""` | no |
| ec2\_key\_enabled | Generate a SSH private key and include in launch template of ECS nodes | `bool` | `false` | no |
| efs\_key\_arn | ARN of a KMS Key to use on EFS volumes | `string` | `""` | no |
| efs\_lifecycle\_transition\_to\_ia | Option to enable EFS Lifecycle Transaction to IA | `string` | `""` | no |
| efs\_lifecycle\_transition\_to\_primary\_storage\_class | Option to enable EFS Lifecycle Transaction to Primary Storage Class | `bool` | `false` | no |
| enable\_schedule | Enables schedule to shut down and start up instances outside business hours. | `bool` | `false` | no |
| extra\_certificate\_arns | Extra ACM certificates to add to ALB Listeners | `list(string)` | `[]` | no |
| extra\_task\_policies\_arn | Extra policies to add to the task definition permissions | `list(string)` | `[]` | no |
| fargate\_only | Enable when cluster is only for fargate and does not require ASG/EC2/EFS infrastructure | `bool` | `false` | no |
| instance\_types | Instance type for ECS workers | `list(any)` | `[]` | no |
| instance\_volume\_size | Volume size for docker volume (in GB). | `number` | `30` | no |
| instance\_volume\_size\_root | Volume size for root volume (in GB). | `number` | `16` | no |
| lb\_access\_logs\_bucket | Bucket to store logs from lb access. | `string` | `""` | no |
| lb\_access\_logs\_prefix | Bucket prefix to store lb access logs. | `string` | `""` | no |
| name | Name of this ECS cluster. | `any` | n/a | yes |
| on\_demand\_base\_capacity | You can designate a base portion of your total capacity as On-Demand. As the group scales, per your settings, the base portion is provisioned first, while additional On-Demand capacity is percentage-based. | `number` | `0` | no |
| on\_demand\_percentage | Percentage of on-demand intances vs spot. | `number` | `100` | no |
| private\_subnet\_ids | List of private subnet IDs for ECS instances and Internal ALB when enabled. | `list(string)` | n/a | yes |
| provisioned\_throughput\_in\_mibps | The throughput, measured in MiB/s, that you want to provision for the file system. | `number` | `0` | no |
| public\_subnet\_ids | List of public subnet IDs for ECS ALB. | `list(string)` | n/a | yes |
| schedule\_cron\_start | Cron expression to define when to trigger a start of the auto-scaling group. E.g. '0 20 \* \* \*' to start at 8pm GMT time. | `string` | `""` | no |
| schedule\_cron\_stop | Cron expression to define when to trigger a stop of the auto-scaling group. E.g. '0 10 \* \* \*' to stop at 10am GMT time. | `string` | `""` | no |
| secure\_subnet\_ids | List of secure subnet IDs for EFS. | `list(string)` | n/a | yes |
| security\_group\_ecs\_nodes\_outbound\_cidrs | ECS Nodes outbound allowed CIDRs for the security group. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| security\_group\_ids | Extra security groups for instances. | `list(string)` | `[]` | no |
| target\_group\_arns | List of target groups for ASG to register. | `list(string)` | `[]` | no |
| throughput\_mode | Throughput mode for the file system. Defaults to bursting. Valid values: bursting, provisioned. | `string` | `"bursting"` | no |
| userdata | Extra commands to pass to userdata. | `string` | `""` | no |
| volume\_type | The EBS volume type | `string` | `"gp2"` | no |
| vpc\_id | VPC ID to deploy the ECS cluster. | `any` | n/a | yes |
| vpn\_cidr | Cidr of VPN to grant ssh access to ECS nodes | `list` | <pre>[<br>  "10.37.0.0/16"<br>]</pre> | no |
| wafv2\_enable | Deploys WAF V2 with Managed rule groups | `bool` | `false` | no |
| wafv2\_managed\_block\_rule\_groups | List of WAF V2 managed rule groups, set to block | `list(string)` | `[]` | no |
| wafv2\_managed\_rule\_groups | List of WAF V2 managed rule groups, set to count | `list(string)` | <pre>[<br>  "AWSManagedRulesCommonRuleSet"<br>]</pre> | no |
| wafv2\_rate\_limit\_rule | The limit on requests per 5-minute period for a single originating IP address (leave 0 to disable) | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb\_arn | n/a |
| alb\_dns\_name | n/a |
| alb\_id | n/a |
| alb\_internal\_arn | n/a |
| alb\_internal\_dns\_name | n/a |
| alb\_internal\_id | n/a |
| alb\_internal\_listener\_https\_arn | n/a |
| alb\_internal\_listener\_test\_traffic\_arn | n/a |
| alb\_internal\_zone\_id | n/a |
| alb\_listener\_https\_arn | n/a |
| alb\_listener\_test\_traffic\_arn | n/a |
| alb\_secgrp\_id | n/a |
| alb\_zone\_id | n/a |
| ecs\_arn | n/a |
| ecs\_codedeploy\_iam\_role\_arn | n/a |
| ecs\_iam\_role\_arn | n/a |
| ecs\_iam\_role\_name | n/a |
| ecs\_id | n/a |
| ecs\_name | n/a |
| ecs\_nodes\_secgrp\_id | n/a |
| ecs\_service\_iam\_role\_arn | n/a |
| ecs\_service\_iam\_role\_name | n/a |
| ecs\_task\_iam\_role\_arn | n/a |
| ecs\_task\_iam\_role\_name | n/a |
| efs\_fs\_id | n/a |
| private\_key\_pem | n/a |

<!--- END_TF_DOCS --->

## WAF V2 Managed rule groups

The official documentation with the list of groups and individual rules is available here: (https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html).

By default, only the Core rule set (a.k.a Common rules) is deployed with WAF, if you want to customise and add more managed groups to the Web ACL you can find the list of groups expected by Terraform following this developer guide: (https://docs.aws.amazon.com/waf/latest/developerguide/waf-using-managed-rule-groups.html).

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-ecs/blob/master/LICENSE) for full details.
