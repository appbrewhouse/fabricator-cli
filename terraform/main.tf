provider "aws" {
  region = var.aws_region
}

locals {
  webapp_repo_name = "${var.app_name}-webapp"
  backend_repo_name = "${var.app_name}-backend"
}

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
}
