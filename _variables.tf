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
variable "alb-only" {
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
  default = []
  description = "Alarm topics to create and alert on ECS instance metrics"
}

variable "expire_backup_efs" {
  default = 0
  description = "Number of days the backup will be expired"
}

variable "target_group_arns" {
  default = []
  type = "list"
  description = "List of target groups for ASG to register"
}

variable "hostname" {
  default     = ""
  description = "Hostname to create DNS record for this app"
}

variable "hostname_blue" {
  default     = ""
  description = "Blue hostname for testing the app"
}

variable "hostname_create" {
  description = "Create hostname in the hosted zone passed?"
  default     = false
}

variable "hosted_zone" {
  default     = ""
  description = "Existing Hosted Zone domain to add hostnames as DNS records"
}
