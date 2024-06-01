terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws" {
  region                   = var.region
  shared_config_files      = [var.aws_config_path]
  shared_credentials_files = [var.aws_credentials_path]
}

