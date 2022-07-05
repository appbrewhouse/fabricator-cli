locals {
  app_name    = var.app_name
  environment = var.environment
  name        = "${local.app_name}-${local.environment}"
  common_tags = {
    environment = var.environment
    owner       = var.app_name
  }
}

module "rdsdb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${local.name}-rdsdb-sg"
  description = "Access to MYSQL DB for entire VPC CIDR block"
  vpc_id      = var.vpc_id

  # Open to CIDRs blocks (rule or from_port+to_port+protocol+description)
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MYSQL access from within VPC"
      cidr_blocks = var.vpc_cidr_block
    },
  ]

  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = local.common_tags
}


module "rdsdb" {
  source  = "terraform-aws-modules/rds/aws"
  version = "4.3.0"

  identifier = "${local.name}-${var.db_name}-db"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 3306

  multi_az               = false
  subnet_ids             = var.database_subnets
  vpc_security_group_ids = [module.rdsdb_sg.security_group_id]
  db_subnet_group_name   = var.database_subnet_group_name

  engine               = "mysql"
  engine_version       = "8.0.28"
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       = "db.t3.large"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = false

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]
  create_cloudwatch_log_group     = true

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  tags = local.common_tags
  db_instance_tags = {
    "Sensitive" = "high"
  }
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  db_subnet_group_tags = {
    "Sensitive" = "high"
  }
}
