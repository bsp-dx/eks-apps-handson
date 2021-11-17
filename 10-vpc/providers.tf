terraform {
  required_version = "= 1.0.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.65.0"
    }
  }

}

provider "aws" {
  region                  = var.context.aws_region
  profile                 = var.context.aws_profile
  shared_credentials_file = var.context.aws_credentials_file
}