module "ctx" {
  source = "../context"
}

module "eks" {
  source                      = "../module/tfmodule-aws-eks"

  context                       = module.ctx.context
  # aws-auth 설정
  iam_admin_role_arn            = aws_iam_role.admin.arn
  iam_viewer_role_arn           = aws_iam_role.viewer.arn

  # for EKS
  cluster_name                  = local.cluster_name
  cluster_version               = "1.21"
  cluster_service_ipv4_cidr     = "10.21.0.0/16"

  vpc_id                        = data.aws_vpc.this.id
  subnets                       = data.aws_subnet_ids.subnets.ids

  workers_additional_policies = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM" ]

  map_users = [
    {
      userarn  = "arn:aws:iam::827519537363:user/seonbo.shim@bespinglobal.com"
      username = "seonbo.shim@bespinglobal.com"
      groups   = ["system:masters"]
    },
  ]

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
    # instance_types = ["m5.large"]
  }

  node_groups = {
    web = {
      instance_types   = ["m5.large"]
      additional_tags  = { Name = "${local.cluster_name}-web" }
      k8s_labels       = { eks-nodegroup = "web"}
      iam_role_arn     = module.eks.worker_iam_role_arn
      capacity_type    = "ON_DEMAND"
      desired_capacity = 1
      min_capacity     = 1
      max_capacity     = 10
      subnets          = data.aws_subnet_ids.web.ids
    }

    api = {
      instance_types   = ["m5.large"]
      additional_tags  = { Name = "${local.cluster_name}-api" }
      k8s_labels       = { eks-nodegroup = "api"}
      iam_role_arn     = module.eks.worker_iam_role_arn
      capacity_type    = "ON_DEMAND"
      desired_capacity = 1
      min_capacity     = 1
      max_capacity     = 10
      subnets          = data.aws_subnet_ids.api.ids
    }
  }

  enable_istio = false

  depends_on = [ aws_iam_role.admin, aws_iam_role.viewer, module.ctx ]

}
