locals {
  name = "${var.app_name}-${var.environment}"

  common_tags = {
    app_name    = var.app_name
    environment = var.environment
  }
}

module "loadbalancer_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${local.name}-loadbalancer-sg"
  description = "Security Group with HTTP open for entire Internet (IPv4 CIDR), egress ports are all world open"
  vpc_id      = var.vpc_id

  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = local.common_tags
}


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.10.0"

  name               = "${local.name}-alb"
  load_balancer_type = "application"
  vpc_id             = var.vpc_id
  subnets            = var.public_subnets
  security_groups    = [module.loadbalancer_sg.security_group_id]

  # # Listeners
  # # HTTP Listener - HTTP to HTTPS Redirect
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  # #   # HTTPS Listener
  https_listeners = [
    # HTTPS Listener Index = 0 for HTTPS 443
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = var.acm_certificate_arn
    },
  ]

  # # HTTPS Listener Rules
  https_listener_rules = [
    {
      https_listener_index = 0
      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]
      conditions = [{
        host_headers = [var.api_dns_name]
      }]
    },
    {
      https_listener_index = 0
      actions = [{
        type         = "fixed-response"
        content_type = "text/plain"
        status_code  = 200
        message_body = "${var.app_name}-${var.environment}-webapp"
      }]
      conditions = [{
        host_headers = [var.webapp_dns_name]
      }]
    },
    {
      https_listener_index = 0
      actions = [{
        type         = "fixed-response"
        content_type = "text/plain"
        status_code  = 200
        message_body = "${var.app_name}-${var.environment}-staticfe"
      }]
      conditions = [{
        host_headers = [var.staticfe_dns_name]
      }]
    },
  ]

  # # Target Groups
  target_groups = [
    {
      name_prefix          = "api-"
      backend_protocol     = "HTTP"
      backend_port         = 8080
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/v1"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      stickiness = {
        enabled         = true
        cookie_duration = 86400
        type            = "lb_cookie"
      }
      protocol_version = "HTTP1"
    }
  ]

  tags = local.common_tags
}
