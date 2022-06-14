locals {
  app_type = "staticfe"
}

module "staticfe_amplify" {
  source = "../../modules/amplify"

  app_name              = var.app_name
  environment           = var.environment
  app_type              = local.app_type
  amplify_app_name      = "${var.app_name}-${var.environment}-amplify-staticfe"
  github_repo_url       = var.github_repo_url
  git_token             = var.git_token
  api_dns_name          = var.api_dns_name
  branch_name           = var.branch_name
  amplify_app_framework = var.amplify_app_framework
  amplify_app_stage     = var.amplify_app_stage
  domain_name           = var.domain_name
  sub_domain            = var.sub_domain
}
