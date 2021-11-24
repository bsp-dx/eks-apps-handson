module "ctx" {
  source = "../context"
}

module "eks" {
  source                      = "../module/tfmodule-aws-eks"

  context                       = module.ctx.context

  # for EKS
  cluster_name                  = local.cluster_name
  cluster_version               = "1.21"
  cluster_service_ipv4_cidr     = "10.21.0.0/16"

  # for VPC
  vpc_id                        = data.aws_vpc.this.id
  subnets                       = data.aws_subnet_ids.subnets.ids

  # for custom
  iam_admin_role_arn            = aws_iam_role.admin.arn

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
    instance_types = ["m5.large"]
    ami_type  = "AL2_x86_64"
    disk_size = 50
    capacity_type    = "ON_DEMAND"
    iam_role_arn     = module.eks.worker_iam_role_arn
    desired_capacity = 1
    min_capacity     = 1
    max_capacity     = 10
  }

  node_groups = {
    web = {
      additional_tags  = { Name = "${local.cluster_name}-web" }
      k8s_labels       = { eks-nodegroup = "web"}
      subnets          = data.aws_subnet_ids.web.ids
    }

    api = {
      additional_tags  = { Name = "${local.cluster_name}-api" }
      k8s_labels       = { eks-nodegroup = "api"}
      subnets          = data.aws_subnet_ids.api.ids
    }
  }

  enable_istio = true
  depends_on = [ aws_iam_role.admin, aws_iam_role.viewer, module.ctx ]

}
