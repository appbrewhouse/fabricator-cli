terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.25.0-alpha"
    }
  }
}

provider "github" {
  token = var.git_token
  owner = var.org_name
}

# Team
resource "github_team" "app_team" {
  name        = "${var.app_name}-${var.app_type}-team"
  description = "Team for ${var.app_name} - ${var.app_type}"
}

resource "github_membership" "info_user" {
  count    = length(var.collaborators_usernames)
  username = var.collaborators_usernames[count.index]
  role     = "admin"
}

resource "github_team_members" "app_team_members" {
  team_id = github_team.app_team.id

  count = length(var.collaborators_usernames)
  members {
    username = var.collaborators_usernames[count.index]
  }
}

resource "github_repository" "repo" {
  name         = var.repo_name
  description  = var.repo_name
  visibility   = "private"
  has_issues   = true
  has_projects = true
  auto_init    = true

  template {
    owner      = var.github_template_owner_name
    repository = var.github_template_repository_name
  }
}

resource "github_team_repository" "team_repo" {
  team_id    = github_team.app_team.id
  repository = github_repository.repo.name
  permission = "admin"
}

resource "github_repository_project" "project" {
  name       = "A github project for ${var.repo_name} repository"
  repository = github_repository.repo.name
}

resource "github_branch" "staging" {
  repository = github_repository.repo.name
  branch     = var.staging_branch_name

  source_branch = github_repository.repo.branches[0].name
}
