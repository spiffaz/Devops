terraform {
  required_version = ">= 1.2.0"
  backend "s3" {
    bucket = "spiffaz-infrastructure"
    key    = "terraform/tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

