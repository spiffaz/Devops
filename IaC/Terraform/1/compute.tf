# launch configuration for app servers (tier 1)
# if the ips of the servers are needed at launch, the autoscaling groups can be changed to aws_instances and a variable can be set for the count of instances
resource "aws_launch_configuration" "app_server" {
  name            = "app"
  image_id        = var.app_server_image_id
  instance_type   = var.app_server_instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.app_server.id]
  lifecycle {
    create_before_destroy = true
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo su
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo ' <html><body><h1> Check out my page for AWS 3 Tier Architecture </h1></body></html> ' >> /var/www/html/index.html
  EOF
}

resource "aws_autoscaling_group" "app_server" {
  name_prefix          = "app-"
  launch_configuration = aws_launch_configuration.app_server.name
  max_size             = var.app_server_max_no
  min_size             = var.app_server_min_no
  vpc_zone_identifier  = aws_subnet.public.*.id
  target_group_arns    = [aws_lb_target_group.app_lb_tg.arn]
  health_check_type    = "ELB"
  tag {
    key                 = "Name"
    value               = "${var.default_tags.project}-app-server"
    propagate_at_launch = true
  }

  depends_on = [aws_nat_gateway.nat]
}

# middleware server
resource "aws_launch_configuration" "middleware_server" {
  name                 = "middleware"
  image_id             = var.middleware_server_image_id
  instance_type        = var.middleware_server_instance_type
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.database_instance_profile.arn

  security_groups = [aws_security_group.middleware_server.id]
  lifecycle {
    create_before_destroy = true
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo su
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo ' <html><body><h1> Check out my page for AWS 3 Tier Architecture </h1></body></html> ' >> /var/www/html/index.html
  EOF

}

resource "aws_autoscaling_group" "middleware_server" {
  name_prefix          = "mid-"
  launch_configuration = aws_launch_configuration.middleware_server.name
  max_size             = var.middleware_server_max_no
  min_size             = var.middleware_server_min_no
  vpc_zone_identifier  = aws_subnet.middleware.*.id
  target_group_arns    = [aws_lb_target_group.mid_lb_tg.arn]
  health_check_type    = "ELB"

  tag {
    key                 = "Name"
    value               = "${var.default_tags.project}-middleware-server"
    propagate_at_launch = true
  }

  depends_on = [aws_nat_gateway.nat]
}
