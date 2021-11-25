module "ctx" {
  source = "../context"
}

module "eks" {
  source = "../module/tfmodule-aws-eks"

  context = module.ctx.context

  # for EKS
  cluster_version           = "1.21"
  cluster_service_ipv4_cidr = "10.21.0.0/16"
  # cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # for VPC
  vpc_id  = data.aws_vpc.this.id
  subnets = data.aws_subnet_ids.subnets.ids

  # for custom
  iam_admin_role_arn = aws_iam_role.admin.arn

  workers_additional_policies = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  ]

  map_users = [
    {
      userarn  = "arn:aws:iam::827519537363:user/seonbo.shim@bespinglobal.com"
      username = "seonbo.shim@bespinglobal.com"
      groups   = ["system:masters"]
    },
  ]

  node_groups_defaults = {
    instance_types   = ["m5.large"]
    ami_type         = "AL2_x86_64"
    disk_size        = 50
    capacity_type    = "ON_DEMAND"
    iam_role_arn     = module.eks.worker_iam_role_arn
    desired_capacity = 1
    min_capacity     = 1
    max_capacity     = 8
  }

  node_groups = {
    web = {
      desired_capacity = 1
      min_capacity     = 1
      max_capacity     = 4
      k8s_labels       = { eks-nodegroup = "web" }
      subnets          = data.aws_subnet_ids.web.ids
    }

    api = {
      instance_types = ["m5.xlarge"]
      k8s_labels     = { eks-nodegroup = "api" }
      subnets        = data.aws_subnet_ids.api.ids
    }
  }

  enable_istio = true
  depends_on   = [aws_iam_role.admin, module.ctx]

}

