locals {
  app_type = "backend"

  app_name    = var.app_name
  environment = var.environment
  name        = "${local.app_name}-${local.environment}"

  common_tags = {
    environment = var.environment
    owner       = var.app_name
  }
}

resource "aws_iam_policy" "policy" {
  name        = "${var.app_name}-policy"
  description = "EC2 Policy for sending logs to cloudwatch"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "autoscaling:Describe*",
          "cloudwatch:*",
          "logs:*",
          "sns:*",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetRole"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:CreateServiceLinkedRole",
        "Resource" : "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*",
        "Condition" : {
          "StringLike" : {
            "iam:AWSServiceName" : "events.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "role" {
  name = "${local.name}-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach-policy" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "log_profile" {
  name = "${local.name}_logs_profile"
  role = aws_iam_role.role.name
}

module "backend_rds" {
  source = "../../modules/rdsdb"

  app_name                   = var.app_name
  environment                = var.environment
  vpc_id                     = var.vpc_id
  vpc_cidr_block             = var.vpc_cidr_block
  db_name                    = var.db_name
  db_username                = var.db_username
  db_password                = var.db_password
  database_subnets           = var.database_subnets
  database_subnet_group_name = var.database_subnet_group_name
}

data "aws_ami" "api_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["${var.app_name}-ec2-*"]
  }
}

module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${local.name}-private-sg"
  description = "Security Group with HTTP & SSH port open for entire VPC Block (IPv4 CIDR), egress ports are all world open"
  vpc_id      = var.vpc_id

  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["ssh-tcp", "http-80-tcp", "http-8080-tcp"]
  ingress_cidr_blocks = [var.vpc_cidr_block]

  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = local.common_tags
}


resource "aws_launch_template" "launch_template" {
  name_prefix   = "${local.name}-launch_template"
  description   = "Launch template"
  image_id      = data.aws_ami.api_ami.id
  instance_type = var.instance_type

  vpc_security_group_ids = [module.private_sg.security_group_id]
  key_name               = var.instance_keypair

  user_data = base64encode(templatefile("api-install.tmpl", {
    rds_db_hostname = module.backend_rds.db_instance_address
    rds_db_port     = module.backend_rds.db_instance_port
    rds_db_name     = module.backend_rds.db_instance_name
    rds_db_username = module.backend_rds.db_instance_username
    rds_db_password = module.backend_rds.db_instance_password
    server_port     = var.api_port
    awslog_group    = "feteclub-logs"
  }))

  ebs_optimized = true

  update_default_version = true

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 20
      delete_on_termination = true
      volume_type           = "gp2"
    }
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = local.name
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.log_profile.name
  }
}


module "backend" {
  source = "../../modules/asg"

  app_name                = var.app_name
  environment             = var.environment
  private_instance_count  = var.private_instance_count
  launch_template_id      = aws_launch_template.launch_template.id
  launch_template_version = aws_launch_template.launch_template.latest_version
  private_subnets         = var.private_subnets
  target_group_arns       = var.target_group_arns
}
