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

variable "vpc_id" {
  description = "VPC ID to deploy the ECS cluster"
}

variable "private_subnet_ids" {
  type        = "list"
  description = "List of private subnet IDs for ECS instances"
}

variable "public_subnet_ids" {
  type        = "list"
  description = "List of public subnet IDs for ECS ALB"
}

variable "secure_subnet_ids" {
  type        = "list"
  description = "List of secure subnet IDs for EFS"
}

variable "certificate_arn" {}


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

# == OPTIONAL VARS

variable "security_group_ids" {
  type        = "list"
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
  default = []
  description = "Alarm topics to create and alert on ECS instance metrics"
}


variable "expire_backup_efs" {
  default = 0
  description = "Number of days the backup will be expired"
}


variable "alarm_ecs_high_cpu_threshold" {
  description = "Max threshold average CPU percentage allowed in a 2 minutes interval (use 0 to disable this alarm)."
  default     = 80
}

variable "alarm_ecs_high_memory_threshold" {
  description = "Max threshold average Memory percentage allowed in a 2 minutes interval (use 0 to disable this alarm)."
  default     = 80
}

variable "alarm_prefix" {
  type        = string
  description = "String prefix for cloudwatch alarms. (Optional)"
  default     = "alarm"
}

variable "alarm_alb_500_errors_threshold" {
  description = "Max threshold of HTTP 500 errors allowed in a 5 minutes interval (use 0 to disable this alarm)."
  default     = 10
}

variable "alarm_alb_400_errors_threshold" {
  description = "Max threshold of HTTP 4000 errors allowed in a 5 minutes interval (use 0 to disable this alarm)."
  default     = 10
}

variable "alarm_alb_latency_anomaly_threshold" {
  description = "ALB Latency anomaly detection width (use 0 to disable this alarm)."
  default     = 2
}

variable "alarm_asg_high_cpu_threshold" {
  description = "Max threshold average CPU percentage allowed in a 2 minutes interval (use 0 to disable this alarm)."
  default     = 80
}

variable "alarm_efs_credits_low_threshold" {
  description = "Alerts when EFS credits fell below this number in bytes - default 1000000000000 is 1TB of a maximum of 2.31T of credits (use 0 to disable this alarm)."
  default     = 1000000000000
}
