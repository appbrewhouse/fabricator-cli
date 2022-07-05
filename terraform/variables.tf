variable "aws_region" {
  description = "AWS region where the resources are created"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "docker_username" {
  description = "DockerHub username"
  type        = string
}

variable "docker_password" {
  description = "DockerHub password"
  type        = string
}

variable "git_token" {
  type = string
}

variable "org_name" {
  type = string
}

variable "app_name" {
  type = string
}

variable "webapp_collaborators_usernames" {
  type = list(string)
}

variable "staticfe_collaborators_usernames" {
  type = list(string)
}

variable "backend_collaborators_usernames" {
  type = list(string)
}

variable "api_dns_name" {
  type = string
}

variable "webapp_dns_name" {
  type = string
}

variable "staticfe_dns_name" {
  type = string
}

variable "branch_name" {
  type = string
}

variable "amplify_app_framework" {
  type = string
}

variable "amplify_app_stage" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "webapp_sub_domain" {
  type = list(string)
}

variable "staticfe_sub_domain" {
  type = list(string)
}

variable "staging_branch_name" {
  type = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
}

variable "vpc_availability_zones" {
  description = "VPC Availability Zones"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type        = list(string)
}

variable "vpc_database_subnets" {
  description = "VPC Database Subnets"
  type        = list(string)
}

variable "vpc_create_database_subnet_group" {
  description = "VPC Create Database Subnet Group"
  type        = bool
}

variable "vpc_create_database_subnet_route_table" {
  description = "VPC Create Database Subnet Route Table"
  type        = bool
}


variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateways for Private Subnets Outbound Communication"
  type        = bool
}

variable "vpc_single_nat_gateway" {
  description = "Enable only single NAT Gateway in one Availability Zone to save costs during our demos"
  type        = bool
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
