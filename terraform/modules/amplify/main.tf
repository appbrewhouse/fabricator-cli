resource "aws_amplify_app" "app" {
  name = var.amplify_app_name

  repository   = var.github_repo_url
  access_token = var.git_token

  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - npm install
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: /build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  tags = {
    app_type    = var.app_type
    app_name    = var.app_name
    environment = var.environment
  }

  environment_variables = {
    NODE_ENV          = var.environment
    REACT_APP_API_URL = var.api_dns_name
  }
}

resource "aws_amplify_branch" "branch" {
  app_id            = aws_amplify_app.app.id
  branch_name       = var.branch_name
  framework         = var.amplify_app_framework
  enable_auto_build = true
  stage             = var.amplify_app_stage
}

resource "aws_amplify_domain_association" "domain" {
  app_id      = aws_amplify_app.app.id
  domain_name = var.domain_name

  count = length(var.sub_domain)
  sub_domain {
    branch_name = aws_amplify_branch.branch.branch_name
    prefix      = var.sub_domain[count.index]
  }
}
