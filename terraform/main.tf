provider "aws" {
  region = var.aws_region
}

provider "github" {
  owner = var.org_name
}

locals {
  webapp_repo_name   = "${var.app_name}-webapp"
  backend_repo_name  = "${var.app_name}-backend"
  staticfe_repo_name = "${var.app_name}-staticfe"
}

# AWS Access Keys

module "aws_iam_data" {
  source = "./modules/iam"
}

# Github
module "webapp_github" {
  source = "./modules/github"

  depends_on                      = [module.aws_iam_data]
  git_token                       = var.git_token
  org_name                        = var.org_name
  app_name                        = var.app_name
  app_type                        = "webapp"
  collaborators_usernames         = var.webapp_collaborators_usernames
  repo_name                       = local.webapp_repo_name
  github_template_owner_name      = "appbrewhouse"
  github_template_repository_name = "fabricator-webapp-react-template"
  staging_branch_name             = var.staging_branch_name
  secrets = [
    {
      key    = "AWS_ACCESS_KEY_ID",
      secret = module.aws_iam_data.iam_access_id
    },
    {
      key    = "AWS_SECRET_ACCESS_KEY",
      secret = module.aws_iam_data.iam_access_secret
    },
    {
      key    = "AWS_DEFAULT_REGION",
      secret = var.aws_region
    },
    {
      key    = "APP_NAME",
      secret = var.app_name
    }
  ]
}

module "staticfe_github" {
  source = "./modules/github"

  depends_on                      = [module.aws_iam_data]
  git_token                       = var.git_token
  org_name                        = var.org_name
  app_name                        = var.app_name
  app_type                        = "staticfe"
  collaborators_usernames         = var.staticfe_collaborators_usernames
  repo_name                       = local.staticfe_repo_name
  github_template_owner_name      = "appbrewhouse"
  github_template_repository_name = "fabricator-staticfe-gatsby-template"
  staging_branch_name             = var.staging_branch_name
  secrets = [
    {
      key    = "AWS_ACCESS_KEY_ID",
      secret = module.aws_iam_data.iam_access_id
    },
    {
      key    = "AWS_SECRET_ACCESS_KEY",
      secret = module.aws_iam_data.iam_access_secret
    },
    {
      key    = "AWS_DEFAULT_REGION",
      secret = var.aws_region
    },
    {
      key    = "APP_NAME",
      secret = var.app_name
    }
  ]
}

module "backend_github" {
  source = "./modules/github"

  depends_on                      = [module.aws_iam_data]
  git_token                       = var.git_token
  org_name                        = var.org_name
  app_name                        = var.app_name
  app_type                        = "backend"
  collaborators_usernames         = var.backend_collaborators_usernames
  repo_name                       = local.backend_repo_name
  github_template_owner_name      = "appbrewhouse"
  github_template_repository_name = "fabricator-backend-node-template"
  staging_branch_name             = var.staging_branch_name
  secrets = [
    {
      key    = "AWS_ACCESS_KEY_ID",
      secret = module.aws_iam_data.iam_access_id
    },
    {
      key    = "AWS_SECRET_ACCESS_KEY",
      secret = module.aws_iam_data.iam_access_secret
    },
    {
      key    = "AWS_DEFAULT_REGION",
      secret = var.aws_region
    },
    {
      key    = "DOCKER_USERNAME",
      secret = var.docker_username
    },
    {
      key    = "DOCKER_PASSWORD",
      secret = var.docker_password
    },
    {
      key    = "APP_NAME",
      secret = var.app_name
    }
  ]
}

# AWS Routing
module "routing" {
  source = "./modules/routing"

  domain_name = var.domain_name
  environment = var.environment
}

# AWS VPC
module "aws_vpc" {
  source = "./modules/vpc"

  app_name    = var.app_name
  environment = var.environment

  vpc_cidr_block                         = var.vpc_cidr_block
  vpc_availability_zones                 = var.vpc_availability_zones
  vpc_public_subnets                     = var.vpc_public_subnets
  vpc_private_subnets                    = var.vpc_private_subnets
  vpc_database_subnets                   = var.vpc_database_subnets
  vpc_create_database_subnet_group       = var.vpc_create_database_subnet_group
  vpc_create_database_subnet_route_table = var.vpc_create_database_subnet_route_table
  vpc_enable_nat_gateway                 = var.vpc_enable_nat_gateway
  vpc_single_nat_gateway                 = var.vpc_single_nat_gateway
}

# AWS ALB
module "aws_alb" {
  source = "./modules/alb"

  app_name            = var.app_name
  environment         = var.environment
  vpc_id              = module.aws_vpc.vpc_id
  public_subnets      = module.aws_vpc.public_subnets
  acm_certificate_arn = module.routing.acm_certificate_arn
  api_dns_name        = var.api_dns_name
  webapp_dns_name     = var.webapp_dns_name
  staticfe_dns_name   = var.staticfe_dns_name
}

# AWS resources

module "staticfe_aws" {
  source = "./applications/staticfe"

  depends_on            = [module.staticfe_github, module.aws_vpc]
  github_repo_url       = module.staticfe_github.github_repo_url
  git_token             = var.git_token
  app_name              = var.app_name
  environment           = var.environment
  api_dns_name          = var.api_dns_name
  branch_name           = var.branch_name
  amplify_app_framework = var.amplify_app_framework
  amplify_app_stage     = var.amplify_app_stage
  domain_name           = var.domain_name
  sub_domain            = var.staticfe_sub_domain

  zone_id     = module.routing.domain_zoneid
  dns_name    = var.staticfe_dns_name
  lb_dns_name = module.aws_alb.lb_dns_name
  lb_zone_id  = module.aws_alb.lb_zone_id
}

module "webapp_aws" {
  source = "./applications/webapp"

  depends_on            = [module.webapp_github, module.aws_vpc, module.staticfe_aws]
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

  zone_id     = module.routing.domain_zoneid
  dns_name    = var.webapp_dns_name
  lb_dns_name = module.aws_alb.lb_dns_name
  lb_zone_id  = module.aws_alb.lb_zone_id
}

module "backend_aws" {
  source = "./applications/backend"

  depends_on             = [module.backend_github, module.aws_vpc]
  app_name               = var.app_name
  environment            = var.environment
  instance_type          = var.instance_type
  instance_keypair       = var.instance_keypair
  private_instance_count = var.private_instance_count
  api_port               = 3000

  vpc_id            = module.aws_vpc.vpc_id
  vpc_cidr_block    = module.aws_vpc.vpc_cidr_block
  private_subnets   = module.aws_vpc.private_subnets
  target_group_arns = module.aws_alb.target_group_arns

  db_name                    = var.db_name
  db_username                = var.db_username
  db_password                = var.db_password
  database_subnets           = var.vpc_database_subnets
  database_subnet_group_name = module.aws_vpc.database_subnet_group_name
}
