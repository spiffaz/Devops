resource "aws_lb" "app_lb" {
  name_prefix                = "app-"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.app_lb.id]
  subnets                    = aws_subnet.public.*.id
  idle_timeout               = 60
  ip_address_type            = "dualstack"
  enable_deletion_protection = false

  tags = {
    "Name" = "${var.default_tags.project}-app-load-balancer"
  }
}

resource "aws_lb_target_group" "app_lb_tg" {
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  name_prefix = "app-" # max 6 characters

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 60
    protocol            = "HTTP"
  }

  tags = { "Name" = "${var.default_tags.project}-app-target-group" }
}

resource "aws_lb_listener" "app_lb" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb_tg.arn
  }
}

# middleware load balancer
resource "aws_lb" "mid_lb" {
  name_prefix                = "mid-"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.middleware_lb.id]
  subnets                    = aws_subnet.public.*.id
  ip_address_type            = "ipv4"
  enable_deletion_protection = false

  tags = {
    "Name" = "${var.default_tags.project}-middleware-load-balancer"
  }
}

resource "aws_lb_target_group" "mid_lb_tg" {
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  name_prefix = "mid-" # max 6 characters

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 60
    protocol            = "HTTP"
  }

  tags = { "Name" = "${var.default_tags.project}-middleware-target-group" }
}

resource "aws_lb_listener" "mid_lb" {
  load_balancer_arn = aws_lb.mid_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mid_lb_tg.arn
  }
}
