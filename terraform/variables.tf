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
