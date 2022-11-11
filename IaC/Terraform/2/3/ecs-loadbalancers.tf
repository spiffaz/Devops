# client load balancer
resource "aws_lb" "client_lb" {
  name_prefix        = "cl-"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.client_lb.id]
  subnets            = aws_subnet.public.*.id
  idle_timeout       = 60
  ip_address_type    = "dualstack"

  tags = {
    "Name" = "${var.default_tags.project}-client-lb"
  }
}

# client load balancer target group
resource "aws_lb_target_group" "client_lb_targets" {
  name_prefix          = "cl-"
  port                 = 9090
  protocol             = "HTTP"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = 30
  target_type          = "ip"

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 60
    protocol            = "HTTP"
  }

  tags = { "Name" = "${var.default_tags.project}-client-tg" }
}

# client load balancer listener
resource "aws_lb_listener" "client_lb" {
  load_balancer_arn = aws_lb.client_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.client_lb_targets.arn
  }
}

# fruits load balancer
resource "aws_lb" "fruits_lb" {
  name_prefix        = "fr-"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.fruits_lb.id]
  subnets            = aws_subnet.private.*.id
  idle_timeout       = 60
  ip_address_type    = "ipv4"

  tags = {
    "Name" = "${var.default_tags.project}-fruits-lb"
  }
}

# fruit load balancer target group
resource "aws_lb_target_group" "fruits_lb_targets" {
  name_prefix          = "fr-"
  port                 = 9090
  protocol             = "HTTP"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = 30
  target_type          = "ip"

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 60
    protocol            = "HTTP"
  }

  tags = { "Name" = "${var.default_tags.project}-fruits-tg" }
}

# fruits load balancer listener
resource "aws_lb_listener" "fruits_lb" {
  load_balancer_arn = aws_lb.fruits_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fruits_lb_targets.arn
  }
}

# vegetables load balancer
resource "aws_lb" "vegetables_lb" {
  name_prefix        = "vg-"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.vegetables_lb.id]
  subnets            = aws_subnet.private.*.id
  idle_timeout       = 60
  ip_address_type    = "ipv4"

  tags = {
    "Name" = "${var.default_tags.project}-vegetables-lb"
  }
}

# fruit load balancer target group
resource "aws_lb_target_group" "vegetables_lb_targets" {
  name_prefix          = "vg-"
  port                 = 9090
  protocol             = "HTTP"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = 30
  target_type          = "ip"

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 60
    protocol            = "HTTP"
  }

  tags = { "Name" = "${var.default_tags.project}-vegetables-tg" }
}

# fruits load balancer listener
resource "aws_lb_listener" "vegetables_lb" {
  load_balancer_arn = aws_lb.vegetables_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vegetables_lb_targets.arn
  }
}