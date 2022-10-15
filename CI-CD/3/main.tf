terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.2.0"
}
  
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "Web-Server-Security-Group" {
  name = "Web-Security-Group"
}

resource "aws_security_group_rule" "allow_TLS_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.Web-Server-Security-Group.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.Web-Server-Security-Group.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

}
  
resource "aws_instance" "Web_Server" {
  ami           = "ami-06640050dc3f556bb"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.Web-Server-Security-Group.name]
  key_name = "CICD"
  user_data = "${file("config.sh")}"
  
  tags = {
    Name = var.instance_name
  }
}
  

