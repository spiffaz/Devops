variable "region" {
  type        = string
  description = "Region AWS resources would be deployed in"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.255.0.0/20"
}

variable "default_tags" {
  type        = map(string)
  description = "Map of default tags to apply to resources"
  default = {
    project = "Microservice-Architecture-project"
  }
}

variable "public_subnet_count" {
  type        = number
  description = "Number of public subnets to create"
  default     = 3
}

variable "private_subnet_count" {
  type        = number
  description = "Number of private subnets to create"
  default     = 3
}

variable "client_task_definition_cpu" {
  type        = number
  description = "CPU to be used for fargate client task definition"
  default     = 256
}

variable "client_task_definition_memory" {
  type        = number
  description = "Memory to be used for fargate client task definition"
  default     = 512
}

variable "ecs_client_service_count" {
  type        = number
  description = "Number of ecs client service instances"
  default     = 1
}

variable "database_private_ip" {
  type        = string
  description = "Private ip for database instance"
  default     = "10.255.3.253"
}

variable "ec2_key_pair" {
  type        = string
  description = "Key pair for database instance"
}

variable "database_service_name" {
  type        = string
  description = "Service name to be used by database"
  default     = "database"
}

variable "database_service_message" {
  type        = string
  description = "Database message"
  default     = "Hello from the database"
}

variable "consul_server_count" {
  type        = number
  description = "Count of consul servers"
  default     = 3
}

variable "consul_server_allowed_cidr_blocks" {
  type        = list(string)
  description = "List of valid IPv4 CIDR blocks that can access the consul servers from the public internet."
  default     = ["0.0.0.0/0"]
}

variable "consul_server_allowed_cidr_blocks_ipv6" {
  type        = list(string)
  description = "List of valid IPv6 CIDR blocks that can access the consul servers from the public internet."
  default     = ["::/0"]
}

variable "consul_dc1_name" {
  type        = string
  description = "Name of Consul datacenter"
  default     = "dc1"
}