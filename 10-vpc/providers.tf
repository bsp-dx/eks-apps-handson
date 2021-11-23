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
  region                  = "ap-northeast-2"
  profile                 = "terran"
  shared_credentials_file = "$HOME/.aws/credentials"
}