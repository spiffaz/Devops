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

# security group for fruits service
resource "aws_security_group" "ecs_fruits_service" {
  name_prefix = "${var.default_tags.project}-ecs-fruits-service"
  description = "ECS fruits service security group."
  vpc_id      = aws_vpc.main.id
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

# security group for vegetables service
resource "aws_security_group" "ecs_vegetables_service" {
  name_prefix = "${var.default_tags.project}-ecs-vegetables-service"
  description = "ECS vegetables service security group."
  vpc_id      = aws_vpc.main.id
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

resource "aws_security_group_rule" "consul_server_allow_server_8501" {
  security_group_id = aws_security_group.consul_server.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8501
  to_port           = 8501
  self              = true
  description       = "Allow HTTPS API traffic from Consul Server to Server."
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

# Access From the Consul Client to Consul Servers
resource "aws_security_group_rule" "consul_server_allow_client_8300" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8300
  to_port                  = 8300
  source_security_group_id = aws_security_group.consul_client.id
  description              = "Allow RPC traffic from Consul Client to Server.  For data replication between servers."
}

resource "aws_security_group_rule" "consul_server_allow_client_8301" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8301
  to_port                  = 8301
  source_security_group_id = aws_security_group.consul_client.id
  description              = "Allow LAN gossip traffic from Consul Client to Server.  For data replication between servers."
}

resource "aws_security_group_rule" "consul_server_allow_client_8500" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8500
  to_port                  = 8500
  source_security_group_id = aws_security_group.consul_client.id
  description              = "Allow HTTP API traffic from Consul Client to Server."
}


resource "aws_security_group_rule" "consul_server_allow_client_8501" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8501
  to_port                  = 8501
  source_security_group_id = aws_security_group.consul_client.id
  description              = "Allow HTTPS API traffic from Consul Client to Server."
}

# acl controller security group
resource "aws_security_group" "acl_controller" {
  name_prefix = "${var.default_tags.project}-acl-controller-"
  description = "Consul ACL Controller service security group."
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "acl_controller_allow_inbound_self" {
  security_group_id = aws_security_group.acl_controller.id
  type              = "ingress"
  protocol          = -1
  self              = true
  from_port         = 0
  to_port           = 0
  description       = "Allow traffic from resources with this security group."
}

resource "aws_security_group_rule" "acl_controller_allow_outbound" {
  security_group_id = aws_security_group.acl_controller.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}

# A Generalized group for all consul clients
resource "aws_security_group" "consul_client" {
  name_prefix = "${var.default_tags.project}-consul-client-"
  description = "General security group for consul clients."
  vpc_id      = aws_vpc.main.id
}

# Required for gossip traffic between each client
resource "aws_security_group_rule" "consul_client_allow_inbound_self_8301" {
  security_group_id = aws_security_group.consul_client.id
  type              = "ingress"
  protocol          = "tcp"
  self              = true
  from_port         = 8301
  to_port           = 8301
  description       = "Allow LAN Serf traffic from resources with this security group."
}

# Required to allow the proxies to contact each other
resource "aws_security_group_rule" "consul_client_allow_inbound_self_20000" {
  security_group_id = aws_security_group.consul_client.id
  type              = "ingress"
  protocol          = "tcp"
  self              = true
  from_port         = 20000
  to_port           = 20000
  description       = "Allow Proxy traffic from resources with this security group."
}

resource "aws_security_group_rule" "consul_client_allow_outbound" {
  security_group_id = aws_security_group.consul_client.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}

