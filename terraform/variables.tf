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

variable "backend_collaborators_usernames" {
  type = list(string)
}

variable "api_dns_name" {
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

variable "staging_branch_name" {
  type = string
}
