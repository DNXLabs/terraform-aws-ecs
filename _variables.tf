# == REQUIRED VARS

variable "name" {
  description = "Name of this ECS cluster."
}

variable "instance_types" {
  description = "Instance type for ECS workers"
  type        = list(any)
  default     = []
}

variable "architecture" {
  default     = "x86_64"
  description = "Architecture to select the AMI, x86_64 or arm64"
}
variable "volume_type" {
  default     = "gp2"
  description = "The EBS volume type"
}

variable "on_demand_percentage" {
  description = "Percentage of on-demand intances vs spot."
  default     = 100
}

variable "on_demand_base_capacity" {
  description = "You can designate a base portion of your total capacity as On-Demand. As the group scales, per your settings, the base portion is provisioned first, while additional On-Demand capacity is percentage-based."
  default     = 0
}

variable "vpc_id" {
  description = "VPC ID to deploy the ECS cluster."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for ECS instances and Internal ALB when enabled."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for ECS ALB."
}

variable "secure_subnet_ids" {
  type        = list(string)
  description = "List of secure subnet IDs for EFS."
}

variable "certificate_arn" {}

variable "extra_certificate_arns" {
  type        = list(string)
  description = "Extra ACM certificates to add to ALB Listeners"
  default     = []
}

# == OPTIONAL VARS

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "Extra security groups for instances."
}

variable "security_group_ecs_nodes_outbound_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "ECS Nodes outbound allowed CIDRs for the security group."
}

variable "userdata" {
  default     = ""
  description = "Extra commands to pass to userdata."
}

variable "alb" {
  default     = true
  description = "Whether to deploy an ALB or not with the cluster."
}

variable "alb_http_listener" {
  default     = true
  description = "Whether to enable HTTP listeners"
}

variable "alb_sg_allow_test_listener" {
  default     = true
  description = "Whether to allow world access to the test listeners"
}

variable "alb_sg_allow_egress_https_world" {
  default     = true
  description = "Whether to allow ALB to access HTTPS endpoints - needed when using OIDC authentication"
}

variable "alb_only" {
  default     = false
  description = "Whether to deploy only an alb and no cloudFront or not with the cluster."
}

variable "alb_internal" {
  default     = false
  description = "Deploys a second internal ALB for private APIs."
}

variable "alb_enable_deletion_protection" {
  default     = false
  description = "Enable deletion protection for ALBs"
}

variable "certificate_internal_arn" {
  default     = ""
  description = "certificate arn for internal ALB."
}

variable "alb_ssl_policy" {
  default     = "ELBSecurityPolicy-2016-08"
  type        = string
  description = "The name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS."
}

variable "alb_internal_ssl_policy" {
  default     = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  type        = string
  description = "The name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS."
}

variable "alb_drop_invalid_header_fields" {
  default     = true
  type        = bool
  description = "Indicates whether HTTP headers with invalid header fields are removed by the load balancer (true) or routed to targets (false)."
}

variable "asg_min" {
  default     = 1
  description = "Min number of instances for autoscaling group."
}

variable "asg_max" {
  default     = 4
  description = "Max number of instances for autoscaling group."
}

variable "asg_protect_from_scale_in" {
  default     = false
  description = "(Optional) Allows setting instance protection. The autoscaling group will not select instances with this setting for termination during scale in events."
}

variable "asg_target_capacity" {
  default     = 70
  description = "Target average capacity percentage for the ECS capacity provider to track for autoscaling."
}

variable "alarm_sns_topics" {
  default     = []
  description = "Alarm topics to create and alert on ECS instance metrics."
}

variable "alarm_asg_high_cpu_threshold" {
  description = "Max threshold average CPU percentage allowed in a 2 minutes interval (use 0 to disable this alarm)."
  default     = 80
}

variable "alarm_ecs_high_memory_threshold" {
  description = "Max threshold average Memory percentage allowed in a 2 minutes interval (use 0 to disable this alarm)."
  default     = 80
}

variable "alarm_ecs_high_cpu_threshold" {
  description = "Max threshold average CPU percentage allowed in a 2 minutes interval (use 0 to disable this alarm)."
  default     = 80
}

variable "alarm_alb_latency_anomaly_threshold" {
  description = "ALB Latency anomaly detection width (use 0 to disable this alarm)."
  default     = 2
}

variable "alarm_alb_500_errors_threshold" {
  description = "Max threshold of HTTP 500 errors allowed in a 5 minutes interval (use 0 to disable this alarm)."
  default     = 10
}

variable "alarm_alb_400_errors_threshold" {
  description = "Max threshold of HTTP 4000 errors allowed in a 5 minutes interval (use 0 to disable this alarm)."
  default     = 10
}

variable "alarm_efs_credits_low_threshold" {
  description = "Alerts when EFS credits fell below this number in bytes - default 1000000000000 is 1TB of a maximum of 2.31T of credits (use 0 to disable this alarm)."
  default     = 1000000000000
}

variable "target_group_arns" {
  default     = []
  type        = list(string)
  description = "List of target groups for ASG to register."
}

variable "autoscaling_health_check_grace_period" {
  default     = 300
  description = "The length of time that Auto Scaling waits before checking an instance's health status. The grace period begins when an instance comes into service."
}

variable "autoscaling_default_cooldown" {
  default     = 300
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start."
}

variable "instance_volume_size" {
  description = "Volume size for docker volume (in GB)."
  default     = 30
}

variable "instance_volume_size_root" {
  description = "Volume size for root volume (in GB)."
  default     = 16
}

variable "lb_access_logs_bucket" {
  type        = string
  default     = ""
  description = "Bucket to store logs from lb access."
}

variable "lb_access_logs_prefix" {
  type        = string
  default     = ""
  description = "Bucket prefix to store lb access logs."
}

variable "enable_schedule" {
  default     = false
  description = "Enables schedule to shut down and start up instances outside business hours."
}

variable "schedule_cron_start" {
  type        = string
  default     = ""
  description = "Cron expression to define when to trigger a start of the auto-scaling group. E.g. '0 20 * * *' to start at 8pm GMT time."
}

variable "schedule_cron_stop" {
  type        = string
  default     = ""
  description = "Cron expression to define when to trigger a stop of the auto-scaling group. E.g. '0 10 * * *' to stop at 10am GMT time."
}

variable "backup" {
  type        = string
  default     = "true"
  description = "Assing a backup tag to efs resource - Backup will be performed by AWS Backup."
}

variable "throughput_mode" {
  type        = string
  default     = "bursting"
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: bursting, provisioned."
}

variable "provisioned_throughput_in_mibps" {
  default     = 0
  description = "The throughput, measured in MiB/s, that you want to provision for the file system."
}

variable "alarm_prefix" {
  type        = string
  description = "String prefix for cloudwatch alarms. (Optional)"
  default     = "alarm"
}

variable "ebs_key_arn" {
  type        = string
  description = "ARN of a KMS Key to use on EBS volumes"
  default     = ""
}

variable "efs_key_arn" {
  type        = string
  description = "ARN of a KMS Key to use on EFS volumes"
  default     = ""
}

variable "wafv2_enable" {
  default     = false
  description = "Deploys WAF V2 with Managed rule groups"
}

variable "wafv2_managed_rule_groups" {
  type        = list(string)
  default     = ["AWSManagedRulesCommonRuleSet"]
  description = "List of WAF V2 managed rule groups, set to count"
}

variable "wafv2_managed_block_rule_groups" {
  type        = list(string)
  default     = []
  description = "List of WAF V2 managed rule groups, set to block"
}

variable "wafv2_rate_limit_rule" {
  type        = number
  default     = 0
  description = "The limit on requests per 5-minute period for a single originating IP address (leave 0 to disable)"
}

variable "create_iam_service_linked_role" {
  type        = bool
  default     = false
  description = "Create iam_service_linked_role for ECS or not."
}

variable "fargate_only" {
  default     = false
  description = "Enable when cluster is only for fargate and does not require ASG/EC2/EFS infrastructure"
}

variable "ec2_key_enabled" {
  default     = false
  description = "Generate a SSH private key and include in launch template of ECS nodes"
}

variable "vpn_cidr" {
  default     = ["10.37.0.0/16"]
  description = "Cidr of VPN to grant ssh access to ECS nodes"
}

variable "create_efs" {
  type        = bool
  default     = true
  description = "Enables creation of EFS volume for cluster"
}

variable "asg_capacity_rebalance" {
  type        = bool
  default     = false
  description = "Indicates whether capacity rebalance is enabled"
}

variable "efs_lifecycle_transition_to_ia" {
  type        = string
  default     = ""
  description = "Option to enable EFS Lifecycle Transaction to IA"

  validation {
    condition     = contains(["AFTER_7_DAYS", "AFTER_14_DAYS", "AFTER_30_DAYS", "AFTER_60_DAYS", "AFTER_90_DAYS", ""], var.efs_lifecycle_transition_to_ia)
    error_message = "Indicates how long it takes to transition files to the IA storage class. Valid values: AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, AFTER_90_DAYS. Or leave empty if not used."
  }
}

variable "efs_lifecycle_transition_to_primary_storage_class" {
  type        = bool
  default     = false
  description = "Option to enable EFS Lifecycle Transaction to Primary Storage Class"
}

variable "extra_task_policies_arn" {
  type        = list(string)
  default     = []
  description = "Extra policies to add to the task definition permissions"
}

variable "container_insights" {
  type        = bool
  default     = false
  description = "Enables CloudWatch Container Insights for a cluster."
}