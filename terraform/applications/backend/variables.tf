variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type        = string
  default     = "terraform-key"
}

variable "api_port" {
  description = "API port"
  type        = number
}

variable "private_instance_count" {
  description = "AWS EC2 Private Instances Count"
  type        = number
  default     = 1
}

# Launch Template Outputs
output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.launch_template.id
}

output "launch_template_latest_version" {
  description = "Launch Template Latest Version"
  value       = aws_launch_template.launch_template.latest_version
}

variable "vpc_id" {
  description = "vpc_id"
  type        = string
}

variable "vpc_cidr_block" {
  description = "vpc_cidr_block"
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

variable "db_name" {
  description = "AWS RDS Database Name"
  type        = string
}

variable "db_username" {
  description = "AWS RDS Database Administrator Username"
  type        = string
}

variable "db_password" {
  description = "AWS RDS Database Administrator Password"
  type        = string
  sensitive   = true
}

variable "database_subnets" {
  description = "AWS RDS database_subnets"
  type        = list(string)
}

variable "database_subnet_group_name" {
  description = "AWS RDS database_subnet_group_name"
  type        = string
}
