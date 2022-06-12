data "aws_route53_zone" "domain" {
  name = var.domain_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "3.4.1"

  domain_name = trimsuffix(data.aws_route53_zone.domain.name, ".")
  zone_id     = data.aws_route53_zone.domain.zone_id

  subject_alternative_names = [
    var.domain_name,
    "*.${var.domain_name}"
  ]

  tags = {
    environment = var.environment
  }
}
