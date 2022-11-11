resource "aws_ecs_task_definition" "client" {
  family                   = "${var.default_tags.project}-client"
  requires_compatibilities = ["FARGATE"]
  memory                   = var.client_task_definition_memory
  cpu                      = var.client_task_definition_cpu
  network_mode             = "awsvpc"

  container_definitions = jsonencode([ # convert HCL to json
    {
      name      = "client"
      image     = "nicholasjackson/fake-service:v0.23.1"
      cpu       = 0 # Allows the service to assign the needed cpu to the container
      essential = true

      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "NAME"
          value = "client"
        },
        {
          name  = "MESSAGE"
          value = "Hello from the client!"
        },
        {
          name  = "UPSTREAM_URIS"
          value = "http://${aws_lb.fruits_lb.dns_name}:9090,http://${aws_lb.vegetables_lb.dns_name}:9090"
        }
      ]
    }
  ])
}

# fruits
resource "aws_ecs_task_definition" "fruits" {
  family                   = "${var.default_tags.project}-fruits"
  requires_compatibilities = ["FARGATE"]
  memory                   = var.client_task_definition_memory
  cpu                      = var.client_task_definition_cpu
  network_mode             = "awsvpc"

  container_definitions = jsonencode([ # convert HCL to json
    {
      name      = "fruits"
      image     = "nicholasjackson/fake-service:v0.23.1"
      cpu       = 0 # Allows the service to assign the needed cpu to the container
      essential = true

      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "NAME"
          value = "fruits"
        },
        {
          name  = "MESSAGE"
          value = "Hello from the client!"
        },
        {
          name  = "UPSTREAM_URIS"
          value = "http://${var.database_private_ip}:27017"
        }
      ]
    }
  ])
}

# vegetables
resource "aws_ecs_task_definition" "vegetables" {
  family                   = "${var.default_tags.project}-vegetables"
  requires_compatibilities = ["FARGATE"]
  memory                   = var.client_task_definition_memory
  cpu                      = var.client_task_definition_cpu
  network_mode             = "awsvpc"

  container_definitions = jsonencode([ # convert HCL to json
    {
      name      = "vegetables"
      image     = "nicholasjackson/fake-service:v0.23.1"
      cpu       = 0 # Allows the service to assign the needed cpu to the container
      essential = true

      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "NAME"
          value = "vegetables"
        },
        {
          name  = "MESSAGE"
          value = "Hello from the client!"
        },
        {
          name  = "UPSTREAM_URIS"
          value = "http://${var.database_private_ip}:27017"
        }
      ]
    }
  ])
}