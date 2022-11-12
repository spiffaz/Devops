# client service
resource "aws_ecs_service" "client" {
  name            = "${var.default_tags.project}-client"
  cluster         = aws_ecs_cluster.main.arn
  task_definition = module.client.task_definition_arn
  desired_count   = var.ecs_client_service_count
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.client_lb_targets.arn
    container_name   = "client"
    container_port   = 9090
  }

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs_client_service.id, aws_security_group.consul_client.id]
  }

  propagate_tags = "TASK_DEFINITION"
}

# fruits service
resource "aws_ecs_service" "fruits" {
  name            = "${var.default_tags.project}-fruits"
  cluster         = aws_ecs_cluster.main.arn
  task_definition = module.fruits.task_definition_arn
  desired_count   = 2 #var.ecs_client_service_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs_fruits_service.id, aws_security_group.consul_client.id]
  }

  propagate_tags = "TASK_DEFINITION"
}

# vegetables service
resource "aws_ecs_service" "vegetables" {
  name            = "${var.default_tags.project}-vegetables"
  cluster         = aws_ecs_cluster.main.arn
  task_definition = module.vegetables.task_definition_arn
  desired_count   = 3 #var.ecs_client_service_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs_vegetables_service.id, aws_security_group.consul_client.id]
  }
  propagate_tags = "TASK_DEFINITION"
}

# creates and assigns tokens to new services (consul does not talk to any service without a token)
module "consul_acl_controller" {
  source  = "hashicorp/consul-ecs/aws//modules/acl-controller"
  version = "0.4.1"

  name_prefix     = var.default_tags.project #- would get the error Error: expected length of name to be in the range (1 - 64), got Microservice-Architecture-project-consul-acl-controller-execution) so had to break our normal convention
  ecs_cluster_arn = aws_ecs_cluster.main.arn
  region          = var.region

  consul_bootstrap_token_secret_arn = aws_secretsmanager_secret.consul_bootstrap_token.arn
  consul_server_ca_cert_arn         = aws_secretsmanager_secret.consul_server_root_ca_cert.arn

  # Point to a singular server IP.  Even if its not the leader, the request will be forwarded appropriately
  # this keeps us from using the public facing load balancer
  consul_server_http_addr = "https://${local.server_private_ips[0]}:8501"

  # the ACL controller module creates the required IAM role to allow logging
  log_configuration = local.acl_logs_configuration

  # mapped to an underlying `aws_ecs_service` resource, so its the same format
  security_groups = [aws_security_group.acl_controller.id, aws_security_group.consul_client.id]

  # mapped to an underlying `aws_ecs_service` resource, so its the same format
  subnets = aws_subnet.private.*.id

  depends_on = [
    aws_nat_gateway.nat,
    aws_instance.consul_server # https://github.com/hashicorp/terraform/issues/15285 should work, dsepite count
  ]
}