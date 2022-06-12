provider "aws" {
  region = var.aws_region
}

locals {
  webapp_repo_name  = "${var.app_name}-webapp"
  backend_repo_name = "${var.app_name}-backend"
}

# Github
module "webapp_github" {
  source = "./modules/github"

  git_token                       = var.git_token
  org_name                        = var.org_name
  app_name                        = var.app_name
  app_type                        = "webapp"
  collaborators_usernames         = var.webapp_collaborators_usernames
  repo_name                       = local.webapp_repo_name
  github_template_owner_name      = "appbrewhouse"
  github_template_repository_name = "fabricator-webapp-react-template"
  staging_branch_name             = var.staging_branch_name
}

module "backend_github" {
  source = "./modules/github"

  git_token                       = var.git_token
  org_name                        = var.org_name
  app_name                        = var.app_name
  app_type                        = "backend"
  collaborators_usernames         = var.backend_collaborators_usernames
  repo_name                       = local.backend_repo_name
  github_template_owner_name      = "appbrewhouse"
  github_template_repository_name = "fabricator-backend-node-template"
  staging_branch_name             = var.staging_branch_name
}

# AWS Routing
module "routing" {
  source = "./modules/routing"

  domain_name = var.domain_name
  environment = var.environment
}

# AWS resources
module "webapp_aws" {
  source = "./applications/webapp"

  depends_on            = [module.webapp_github]
  github_repo_url       = module.webapp_github.github_repo_url
  git_token             = var.git_token
  app_name              = var.app_name
  environment           = var.environment
  api_dns_name          = var.api_dns_name
  branch_name           = var.branch_name
  amplify_app_framework = var.amplify_app_framework
  amplify_app_stage     = var.amplify_app_stage
  domain_name           = var.domain_name
  sub_domain            = var.webapp_sub_domain
}
