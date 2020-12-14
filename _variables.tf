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
