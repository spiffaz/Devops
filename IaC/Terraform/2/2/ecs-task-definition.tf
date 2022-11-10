resource "aws_ecs_task_definition" "client" {
  family = "${var.default_tags.project}-client"
  requires_compatibilities = ["FARGATE"]
  memory = var.client_task_definition_memory
  cpu = var.client_task_definition_cpu
  network_mode = "awsvpc"

  container_definitions = jsonencode([ # convert HCL to json
    {
        name = "client"
        image = "nicholasjackson/fake-service:v0.23.1"
        cpu = 10 # Allows the service to assign the needed cpu to the container
        essential = true

        portMappings = [
            {
                containerPort = 9090
                hostPort = 9090
                protocol = "tcp"
            }
        ]

        environment = [
            {
                name = "NAME"
                value = "client"
            },
            {
                name = "MESSAGE"
                value = "Hello from the client!"
            }
        ]
    }
  ])
}