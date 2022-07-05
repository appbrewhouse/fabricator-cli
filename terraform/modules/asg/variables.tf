variable "app_name" {
  type = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "private_instance_count" {
  description = "AWS EC2 Private Instances Count"
  type        = number
  default     = 1
}

variable "launch_template_id" {
  description = "launch_template_id"
  type        = string
}

variable "launch_template_version" {
  description = "launch_template_version"
  type        = string
}

variable "private_subnets" {
  description = "private_subnets"
  type        = list(string)
}

variable "target_group_arns" {
  description = "target_group_arns"
  type        = set(string)
}