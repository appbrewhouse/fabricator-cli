variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "acm_certificate_arn" {
  type = string
}

variable "api_dns_name" {
  type = string
}

variable "webapp_dns_name" {
  type = string
}
