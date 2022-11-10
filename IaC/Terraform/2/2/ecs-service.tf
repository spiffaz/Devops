resource "aws_ecs_service" "client" {
  name = "${var.default_tags.project}-client"
  cluster = aws_ecs_cluster.main.arn
  task_definition = aws_ecs_task_definition.client.arn
  desired_count = var.ecs_client_service_count
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.client_lb_targets.arn
    container_name = "client"
    container_port = 9090
  }

  network_configuration {
    subnets = aws_subnet.private.*.id
    assign_public_ip = false
    security_groups = [aws_security_group.ecs_client_service.id]
  }
}
