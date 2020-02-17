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
  description = "List of private subnet IDs for ECS instances"
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

variable "expire_backup_efs" {
  default     = 0
  description = "Number of days the backup will be expired"
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
  default     = 20
}

variable "instance_volume_size_root" {
  description = "Volume size for root volume (in GB)"
  default     = 16
}
