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
  region      = var.context.aws_region
  profile     = var.context.aws_profile
  shared_credentials_file = var.context.aws_credentials_file
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                    = data.aws_eks_cluster.this.endpoint
  token                   = data.aws_eks_cluster_auth.this.token
  cluster_ca_certificate  = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
}
