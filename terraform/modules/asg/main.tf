locals {
  app_name    = var.app_name
  environment = var.environment
  name        = "${local.app_name}-${local.environment}"
  common_tags = {
    environment = var.environment
    owner       = var.app_name
  }
}

resource "aws_autoscaling_group" "asg" {
  name_prefix      = "${local.name}-"
  max_size         = 10
  min_size         = 1
  desired_capacity = var.private_instance_count

  vpc_zone_identifier = var.private_subnets
  target_group_arns   = var.target_group_arns
  health_check_type   = "EC2"

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  # Instance Refresh
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["desired_capacity"]
  }
  tag {
    key                 = "Owners"
    value               = local.name
    propagate_at_launch = true
  }
}
