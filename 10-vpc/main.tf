# DEFINE VPC
module "vpc" {

  source = "../module/tfmodule-aws-vpc/"

  context = var.context
  cidr    = "${var.vpc_cidr}.0.0/16"

  # for Route53 API routing for private dns
  enable_dns_hostnames = true

  azs                  = ["apne2-az1", "apne2-az3"]

  public_subnets       = ["${var.vpc_cidr}.11.0/24", "${var.vpc_cidr}.12.0/24"]
  public_subnet_names  = ["pub-a1", "pub-c1"]
  public_subnet_suffix = "pub"
  public_subnet_tags   = {
    "kubernetes.io/cluster/${local.name_prefix}-eks" = "shared"
    "kubernetes.io/role/elb" = 1
  }

  enable_nat_gateway = true
  single_nat_gateway = true

  private_subnets = [
    "${var.vpc_cidr}.31.0/24", "${var.vpc_cidr}.32.0/24",
    "${var.vpc_cidr}.41.0/24", "${var.vpc_cidr}.42.0/24",
    "${var.vpc_cidr}.51.0/24", "${var.vpc_cidr}.52.0/24",
  ]
  private_subnet_names = [
    "pri-a1", "pri-c1",
    "web-a1", "web-c1",
    "api-a1", "api-c1",
  ]

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name_prefix}-eks" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }

  database_subnets =  [ "${var.vpc_cidr}.91.0/24", "${var.vpc_cidr}.92.0/24" ]
  database_subnet_names = [ "data-a1", "data-c1"]
  database_subnet_suffix = "data"
  database_subnet_tags = { "grp:Name" = "${local.name_prefix}-data" }

}
