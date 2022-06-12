output "domain_zoneid" {
  description = "The Hosted Zone id of the desired Hosted Zone"
  value       = data.aws_route53_zone.domain.zone_id
}

output "domain_name" {
  description = " The Hosted Zone name of the desired Hosted Zone."
  value       = data.aws_route53_zone.domain.name
}

output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.acm.acm_certificate_arn
}
