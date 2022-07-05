variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  description = "vpc_id"
  type        = string
}

variable "vpc_cidr_block" {
  description = "vpc_cidr_block"
  type        = string
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
