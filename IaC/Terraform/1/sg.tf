resource "aws_security_group" "app_lb" {
  name_prefix = "${var.default_tags.project}-app-lb"
  vpc_id      = aws_vpc.main.id
  description = "security group for application load balancer"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# app server security group
resource "aws_security_group" "app_server" {
  name_prefix = "${var.default_tags.project}-app-server"
  description = "App server security group."
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.app_server.id

  from_port                = 80
  to_port                  = 80
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.app_lb.id
  description              = "Allow incoming traffic from the app load balancer security group to the app server security group."
}

#resource "aws_security_group_rule" "allow_TLS_inbound" {
#  type              = "ingress"
#  security_group_id = aws_security_group.app_server.id
#  from_port   = 22
#  to_port     = 22
#  protocol    = "tcp"
#  cidr_blocks = ["0.0.0.0/0"]
#}

resource "aws_security_group_rule" "app_server_allow_inbound_self" {
  security_group_id = aws_security_group.app_server.id
  type              = "ingress"
  protocol          = -1
  self              = true
  from_port         = 0
  to_port           = 0
  description       = "Allow traffic from resources with this security group."
}

resource "aws_security_group_rule" "allow_all_app_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.app_server.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow all outbound traffic."
}

# middleware load balancer security group
resource "aws_security_group" "middleware_lb" {
  name_prefix = "${var.default_tags.project}-middleware-lb"
  description = "security group for middleware load balancer"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "middleware_lb_inbound_80" {
  security_group_id        = aws_security_group.middleware_lb.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.app_server.id
  description              = "Allow HTTP traffic on port 80."
}

resource "aws_security_group_rule" "middleware_lb_inbound_self" {
  security_group_id = aws_security_group.middleware_lb.id
  type              = "ingress"
  protocol          = -1
  self              = true
  from_port         = 0
  to_port           = 0
  description       = "Allow traffic from resources with this security group."
}

resource "aws_security_group_rule" "allow_all_middleware_lb_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.middleware_lb.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow all outbound traffic."
}

# middleware server security group
resource "aws_security_group" "middleware_server" {
  name_prefix = "${var.default_tags.project}-middleware-server"
  description = "Middleware server security group."
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "allow_middleware_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.middleware_server.id

  from_port                = 80
  to_port                  = 80
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.middleware_lb.id
  description              = "Allow incoming traffic from the middleware load balancer security group to the middleware server security group."
}

resource "aws_security_group_rule" "middleware_server_allow_inbound_self" {
  security_group_id = aws_security_group.middleware_server.id
  type              = "ingress"
  protocol          = -1
  self              = true
  from_port         = 0
  to_port           = 0
  description       = "Allow traffic from resources with this security group."
}

resource "aws_security_group_rule" "allow_all_middleware_server_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.middleware_server.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow all outbound traffic."
}

# database security group
resource "aws_security_group" "db_sg" {
  name_prefix = "${var.default_tags.project}-database-sg"
  description = "Middleware server security group."
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "database_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.db_sg.id

  from_port                = 27017
  to_port                  = 27017
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.middleware_server.id
  description              = "Allow incoming traffic from the middleware server security group to the database server security group."
}

resource "aws_security_group_rule" "allow_all_database_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.db_sg.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow all outbound traffic."
}