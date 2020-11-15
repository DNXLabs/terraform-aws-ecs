# == REQUIRED VARS

variable "name" {
  description = "Name of this ECS cluster"
}

variable "instance_type_1" {
  description = "Instance type for ECS workers (first priority)"
}

variable "instance_type_2" {
  description = "Instance type for ECS workers (second priority)"
}

variable "instance_type_3" {
  description = "Instance type for ECS workers (third priority)"
}

variable "on_demand_percentage" {
  description = "Percentage of on-demand intances vs spot"
  default     = 100
}

variable "on_demand_base_capacity" {
  description = "You can designate a base portion of your total capacity as On-Demand. As the group scales, per your settings, the base portion is provisioned first, while additional On-Demand capacity is percentage-based."
  default     = 0
}

variable "vpc_id" {
  description = "VPC ID to deploy the ECS cluster"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for ECS instances and Internal ALB when enabled"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for ECS ALB"
}

variable "secure_subnet_ids" {
  type        = list(string)
  description = "List of secure subnet IDs for EFS"
}

variable "certificate_arn" {}

# == OPTIONAL VARS

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "Extra security groups for instances"
}

variable "userdata" {
  default     = ""
  description = "Extra commands to pass to userdata"
}

variable "alb" {
  default     = true
  description = "Whether to deploy an ALB or not with the cluster"
}

variable "alb_only" {
  default     = false
  description = "Whether to deploy only an alb and no cloudFront or not with the cluster"
}

variable "alb_internal" {
  default     = false
  description = "Deploys a second internal ALB for private APIs"
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

variable "asg_min" {
  default     = 1
  description = "Min number of instances for autoscaling group"
}

variable "asg_max" {
  default     = 4
  description = "Max number of instances for autoscaling group"
}

variable "asg_memory_target" {
  default     = 60
  description = "Target average memory percentage to track for autoscaling"
}

variable "alarm_sns_topics" {
  default     = []
  description = "Alarm topics to create and alert on ECS instance metrics"
}

variable "alarm_asg_high_cpu_threshold" {
  description = "Max threshold average CPU percentage allowed in a 2 minutes interval (use 0 to disable this alarm)"
  default     = 80
}

variable "alarm_ecs_high_memory_threshold" {
  description = "Max threshold average Memory percentage allowed in a 2 minutes interval (use 0 to disable this alarm)"
  default     = 80
}

variable "alarm_ecs_high_cpu_threshold" {
  description = "Max threshold average CPU percentage allowed in a 2 minutes interval (use 0 to disable this alarm)"
  default     = 80
}

variable "alarm_alb_latency_anomaly_threshold" {
  description = "ALB Latency anomaly detection width (use 0 to disable this alarm)"
  default     = 2
}

variable "alarm_alb_500_errors_threshold" {
  description = "Max threshold of HTTP 500 errors allowed in a 5 minutes interval (use 0 to disable this alarm)"
  default     = 10
}

variable "alarm_alb_400_errors_threshold" {
  description = "Max threshold of HTTP 4000 errors allowed in a 5 minutes interval (use 0 to disable this alarm)"
  default     = 10
}

variable "alarm_efs_credits_low_threshold" {
  description = "Alerts when EFS credits fell below this number in bytes - default 1000000000000 is 1TB of a maximum of 2.31T of credits (use 0 to disable this alarm)"
  default     = 1000000000000
}

variable "target_group_arns" {
  default     = []
  type        = list(string)
  description = "List of target groups for ASG to register"
}

variable "autoscaling_health_check_grace_period" {
  default     = 300
  description = "The length of time that Auto Scaling waits before checking an instance's health status. The grace period begins when an instance comes into service"
}

variable "autoscaling_default_cooldown" {
  default     = 300
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
}

variable "instance_volume_size" {
  description = "Volume size for docker volume (in GB)"
  default     = 22
}

variable "instance_volume_size_root" {
  description = "Volume size for root volume (in GB)"
  default     = 16
}

variable "lb_access_logs_bucket" {
  type        = string
  default     = ""
  description = "Bucket to store logs from lb access"
}

variable "lb_access_logs_prefix" {
  type        = string
  default     = ""
  description = "Bucket prefix to store lb access logs"
}

variable "enable_schedule" {
  default     = false
  description = "Enables schedule to shut down and start up instances outside business hours"
}
variable "schedule_cron_start" {
  type        = string
  default     = ""
  description = "Cron expression to define when to trigger a start of the auto-scaling group. E.g. '0 20 * * *' to start at 8pm GMT time"
}

variable "schedule_cron_stop" {
  type        = string
  default     = ""
  description = "Cron expression to define when to trigger a stop of the auto-scaling group. E.g. '0 10 * * *' to stop at 10am GMT time"
}

variable "backup" {
  type        = string
  default     = "true"
  description = "Assing a backup tag to efs resource - Backup will be performed by AWS Backup"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Extra tags to attach to resources"
}

variable "https_test_listener_from_world_to_alb" {
  default     = true
  description = "Enables Public access to https test listener"
}

variable "container_insights" {
  default     = false
  description = "Enables CloudWatch Container Insights for a cluster."
}