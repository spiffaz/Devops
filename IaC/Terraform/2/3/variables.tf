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
  default     = 2
}

variable "private_subnet_count" {
  type        = number
  description = "Number of private subnets to create"
  default     = 2
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
  default     = "10.255.2.253"
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