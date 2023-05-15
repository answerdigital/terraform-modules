
resource "aws_lb_target_group" "mdm_target_group" {
  name        = "${var.lb_name}-target-group"
  port        = var.application_port
  protocol    = var.application_http_protocol
  target_type = "ip"
  vpc_id      = var.vpc_id

  stickiness {
    enabled     = true
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
  security_groups            = var.security_group_id
  subnets                    = var.subnet_ids
  enable_deletion_protection = true
  tags = {
    Name = "${var.lb_name}-lb"
  }
}

resource "aws_lb_listener" "mdm_lb_listener" {
  load_balancer_arn = aws_lb.aws_lb.arn
  port              = var.application_port
  protocol          = var.application_http_protocol
  default_action {
    target_group_arn = aws_lb_target_group.mdm_target_group.arn
    type             = "forward"
  }
}