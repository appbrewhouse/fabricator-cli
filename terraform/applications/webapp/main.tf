module "webapp_amplify" {
  source = "../../modules/amplify"

  amplify_app_name      = "${var.app_name}-${var.environment}-amplify-webapp"
  github_repo_url       = var.github_repo_url
  git_token             = var.git_token
  app_type              = "webapp"
  app_name              = var.app_name
  environment           = var.environment
  api_dns_name          = var.api_dns_name
  branch_name           = var.branch_name
  amplify_app_framework = var.amplify_app_framework
  amplify_app_stage     = var.amplify_app_stage
  domain_name           = var.domain_name
  sub_domain            = var.sub_domain
}
