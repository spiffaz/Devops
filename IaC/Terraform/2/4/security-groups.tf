# service load balancer security group
resource "aws_security_group" "client_lb" {
  name_prefix = "${var.default_tags.project}-ecs-client-lb"
  description = "security group for client service application load balancer"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "client_lb_inbound_80" {
  security_group_id = aws_security_group.client_lb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow HTTP traffic on port 80."
}

resource "aws_security_group_rule" "client_lb" {
  security_group_id = aws_security_group.client_lb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow all outbound traffic."
}

# security group for client service
resource "aws_security_group" "ecs_client_service" {
  name_prefix = "${var.default_tags.project}-ecs-client-service"
  description = "ECS Client service security group."
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "ecs_client_service_allow_9090" {
  security_group_id        = aws_security_group.ecs_client_service.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 9090
  to_port                  = 9090
  source_security_group_id = aws_security_group.client_lb.id
  description              = "Allow incoming traffic from the client LB to the service container port."
}

resource "aws_security_group_rule" "ecs_client_service_allow_inbound_self" {
  security_group_id = aws_security_group.ecs_client_service.id
  type              = "ingress"
  protocol          = -1
  self              = true
  from_port         = 0
  to_port           = 0
  description       = "Allow traffic from resources with this security group."
}

resource "aws_security_group_rule" "ecs_client_service_allow_outbound" {
  security_group_id = aws_security_group.ecs_client_service.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow all outbound traffic."
}
###################################################################################
# fruits load balancer security group
resource "aws_security_group" "fruits_lb" {
  name_prefix = "${var.default_tags.project}-ecs-fruits-lb"
  description = "security group for fruits service application load balancer"
  vpc_id      = aws_vpc.main.id
}

# fruit lb inbound 
resource "aws_security_group_rule" "fruits_lb_inbound_80" {
  security_group_id        = aws_security_group.client_lb.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.ecs_client_service.id
  description              = "Allow HTTP traffic to fruit lb on port 80."
}

# fruits lb outbound
resource "aws_security_group_rule" "fruits_lb" {
  security_group_id = aws_security_group.fruits_lb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow all outbound traffic."
}

# security group for fruits service
resource "aws_security_group" "ecs_fruits_service" {
  name_prefix = "${var.default_tags.project}-ecs-fruits-service"
  description = "ECS fruits service security group."
  vpc_id      = aws_vpc.main.id
}

# fruit service inbound
resource "aws_security_group_rule" "ecs_fruits_service_allow_9090" {
  security_group_id        = aws_security_group.ecs_fruits_service.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 9090
  to_port                  = 9090
  source_security_group_id = aws_security_group.fruits_lb.id
  description              = "Allow incoming traffic from the fruits LB to the service container port."
}

# fruit service internal traffic
resource "aws_security_group_rule" "ecs_fruits_service_allow_inbound_self" {
  security_group_id = aws_security_group.ecs_fruits_service.id
  type              = "ingress"
  protocol          = -1
  self              = true
  from_port         = 0
  to_port           = 0
  description       = "Allow traffic from resources with this security group."
}

# fruit service outgoing traffic
resource "aws_security_group_rule" "ecs_fruits_service_allow_outbound" {
  security_group_id = aws_security_group.ecs_fruits_service.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow all outbound traffic."
}

#
# vegetables lb
resource "aws_security_group" "vegetables_lb" {
  name_prefix = "${var.default_tags.project}-ecs-vegetables-lb"
  description = "security group for vegetables service application load balancer"
  vpc_id      = aws_vpc.main.id
}

# vegetables lb inbound 
resource "aws_security_group_rule" "vegetables_lb_inbound_80" {
  security_group_id        = aws_security_group.vegetables_lb.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.ecs_client_service.id
  description              = "Allow HTTP traffic to vegetables lb on port 80."
}

# vegetables lb outbound
resource "aws_security_group_rule" "vegetables_lb" {
  security_group_id = aws_security_group.vegetables_lb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow all outbound traffic."
}

# security group for vegetables service
resource "aws_security_group" "ecs_vegetables_service" {
  name_prefix = "${var.default_tags.project}-ecs-vegetables-service"
  description = "ECS vegetables service security group."
  vpc_id      = aws_vpc.main.id
}

# vegetables service inbound
resource "aws_security_group_rule" "ecs_vegetables_service_allow_9090" {
  security_group_id        = aws_security_group.ecs_vegetables_service.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 9090
  to_port                  = 9090
  source_security_group_id = aws_security_group.vegetables_lb.id
  description              = "Allow incoming traffic from the vegetables LB to the service container port."
}

# vegetables service internal traffic
resource "aws_security_group_rule" "ecs_vegetables_service_allow_inbound_self" {
  security_group_id = aws_security_group.ecs_vegetables_service.id
  type              = "ingress"
  protocol          = -1
  self              = true
  from_port         = 0
  to_port           = 0
  description       = "Allow traffic from resources with this security group."
}

# vegetables service outgoing traffic
resource "aws_security_group_rule" "ecs_vegetables_service_allow_outbound" {
  security_group_id = aws_security_group.ecs_vegetables_service.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow all outbound traffic."
}

# security group for database server
resource "aws_security_group" "database" {
  name_prefix = "${var.default_tags.project}-database"
  description = "Database security group."
  vpc_id      = aws_vpc.main.id
}


# allow inbound database from fruit service
resource "aws_security_group_rule" "database_allow_fruits_27017" {
  security_group_id        = aws_security_group.database.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 27017
  to_port                  = 27017
  source_security_group_id = aws_security_group.ecs_fruits_service.id
  description              = "Allow incoming traffic from the vegetables service."
}

# allow inbound database from vegetable service
resource "aws_security_group_rule" "database_allow_vegetables_27017" {
  security_group_id        = aws_security_group.database.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 27017
  to_port                  = 27017
  source_security_group_id = aws_security_group.ecs_vegetables_service.id
  description              = "Allow incoming traffic from the fruits service."
}

# database outgoing traffic
resource "aws_security_group_rule" "database_allow_outbound" {
  security_group_id = aws_security_group.database.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow all outbound traffic."
}

# consul server security group
resource "aws_security_group" "consul_server" {
  name_prefix = "${var.default_tags.project}-consul-server"
  description = "Security group for Consul servers"
  vpc_id      = aws_vpc.main.id
}

# consul 
resource "aws_security_group_rule" "consul_server_allow_8300" {
  security_group_id = aws_security_group.consul_server.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8300
  to_port           = 8300
  self              = true
  description       = "Allow RPC traffic between consul servers for data replication"
}

resource "aws_security_group_rule" "consul_server_allow_8301" {
  security_group_id = aws_security_group.consul_server.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8301
  to_port           = 8301
  self              = true
  description       = "Allow LAN gossip between consul servers for cluster membership, distributed health checks of agents"
}

resource "aws_security_group_rule" "consul_server_allow_8302" {
  security_group_id = aws_security_group.consul_server.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8302
  to_port           = 8302
  self              = true
  description       = "Allow WAN gossip traffic between consul servers for data replication accross data centers"
}

resource "aws_security_group_rule" "consul_server_allow_lb_8500" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8500
  to_port                  = 8500
  source_security_group_id = aws_security_group.consul_server_lb.id
  description              = "Allow HTTP traffic from Load Balancer to the Consul Server API."
}

resource "aws_security_group_rule" "consul_allow_outbound" {
  security_group_id = aws_security_group.consul_server.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow all outbound traffic."
}

# Consul Server lb Security Group
resource "aws_security_group" "consul_server_lb" {
  name_prefix = "${var.default_tags.project}-consul-server-lb"
  description = "Security Group for the consul server lb"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "consul_server_lb_allow_80" {
  security_group_id = aws_security_group.consul_server_lb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = flatten([var.consul_server_allowed_cidr_blocks, [var.vpc_cidr]]) # allow traffic from specified cidr and vpc
  description       = "Allow HTTP traffic."
}

resource "aws_security_group_rule" "consul_server_lb_allow_outbound" {
  security_group_id = aws_security_group.consul_server_lb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}