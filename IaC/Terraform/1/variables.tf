# provider variables
variable "region" {
  type        = string
  description = "Region AWS resources would be deployed in"
  default     = "us-east-1"
}

variable "default_tags" {
  type        = map(string)
  description = "Map of default tags to apply to resources"
  default = {
    project = "3Tier"
  }
}

###############################################################################
# vpc
###############################################################################

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for vpc"
}

variable "public_subnet_count" {
  type        = number
  description = "Number of public subnets to create (Tier 1)"
  default     = 3
}

variable "middleware_subnet_count" {
  type        = number
  description = "Number of middleware subnets to create (Tier 2)"
  default     = 3
}

variable "database_subnet_count" {
  type        = number
  description = "Number of middleware subnets to create (Tier 2)"
  default     = 3
}


###############################################################################
# Compute
###############################################################################

# app server
variable "app_server_image_id" {
  type        = string
  description = "Image id for app server"
  default     = "ami-026b57f3c383c2eec"
}

variable "app_server_instance_type" {
  type        = string
  description = "Instance type for app server"
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "(optional) describe your variable"
}

variable "app_server_max_no" {
  type        = number
  description = "Maximum number of app servers"
  default     = 5
}

variable "app_server_min_no" {
  type        = number
  description = "Minimum number of app servers"
  default     = 2
}

# middleware server
variable "middleware_server_image_id" {
  type        = string
  description = "Image id for middleware server"
  default     = "ami-026b57f3c383c2eec"
}

variable "middleware_server_instance_type" {
  type        = string
  description = "Instance type for middleware server"
  default     = "t2.micro"
}

variable "middleware_server_max_no" {
  type        = number
  description = "Maximum number of middleware servers"
  default     = 5
}

variable "middleware_server_min_no" {
  type        = number
  description = "Minimum number of middleware servers"
  default     = 2
}