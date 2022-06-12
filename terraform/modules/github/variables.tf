variable "git_token" {
  type = string
}

variable "org_name" {
  type = string
}

variable "app_name" {
  type = string
}

variable "app_type" {
  type = string
}

variable "collaborators_usernames" {
  type = list(string)
}

variable "repo_name" {
  type = string
}

variable "github_template_owner_name" {
  type = string
}

variable "github_template_repository_name" {
  type = string
}

variable "staging_branch_name" {
  type = string
}
