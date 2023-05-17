
resource "aws_lb_target_group" "aws_lb_target_group" {
  name        = "${var.lb_name}-target-group"
  port        = var.application_port
  protocol    = var.application_http_protocol
  target_type = "ip"
  vpc_id      = var.vpc_id

  stickiness {
    enabled     = var.sticky_session ? true : false
    type        = "lb_cookie"
    cookie_name = "lb_cookie"
  }

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 50
    matcher             = 200
    path                = var.healthcheck_endpoint
    port                = var.application_port
    protocol            = var.application_http_protocol
    timeout             = 10
    unhealthy_threshold = 3
  }
}

resource "aws_lb" "aws_lb" {
  name                       = "${var.lb_name}-lb"
  internal                   = var.internal
  load_balancer_type         = "application"
  security_groups            = var.vpc_security_group_ids
  subnets                    = var.subnet_ids
  enable_deletion_protection = true
  tags = {
    Name = "${var.lb_name}-lb"
  }

  drop_invalid_header_fields = true
}

resource "aws_lb_listener" "aws_lb_listener" {
  load_balancer_arn = aws_lb.aws_lb.arn
  port              = var.application_port
  protocol          = var.application_http_protocol
  default_action {
    target_group_arn = aws_lb_target_group.aws_lb_target_group.arn
    type             = "forward"
  }
}