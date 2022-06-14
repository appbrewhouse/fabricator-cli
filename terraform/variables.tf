variable "aws_region" {
  description = "AWS region where the resources are created"
  type        = string
}

variable "environment" {
  description = "Environment"
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

