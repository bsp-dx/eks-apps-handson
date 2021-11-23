terraform {
  required_version = "= 1.0.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.65.0"
    }

    kubernetes = {
      source  = "registry.terraform.io/hashicorp/kubernetes"
      version = "~> 2.1.0"
    }
  }
}

provider "aws" {
  region                  = "ap-northeast-2"
  profile                 = "terran"
  shared_credentials_file = "$HOME/.aws/credentials"
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_id
}

locals {
  eks_endpoint       = data.aws_eks_cluster.this.endpoint
  eks_auth_token     = data.aws_eks_cluster_auth.this.token
  eks_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
}

provider "kubernetes" {
  host                   = local.eks_endpoint
  token                  = local.eks_auth_token
  cluster_ca_certificate = local.eks_ca_certificate
}
