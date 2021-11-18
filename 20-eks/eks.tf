module "eks" {
  source                      = "../module/tfmodule-aws-eks"

  context                       = var.context
  # aws-auth 설정
  iam_admin_role_arn            = aws_iam_role.admin.arn
  iam_viewer_role_arn           = aws_iam_role.viewer.arn

  # for EKS
  cluster_version               = "1.21"
  cluster_service_ipv4_cidr     = "10.21.0.0/16"
  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  cluster_endpoint_private_access = true
  cluster_endpoint_private_access_cidrs = ["0.0.0.0/0"]

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
  }

  node_groups = {
    web = {
      instance_types   = ["m5.large"]
      k8s_labels       = { eks-nodegroup = "web"}
      iam_role_arn     = module.eks.worker_iam_role_arn
      capacity_type    = "ON_DEMAND"
      desired_capacity = 1
      min_capacity     = 1
      max_capacity     = 6
      subnets          = data.aws_subnet_ids.web.ids
    }

    api = {
      instance_types   = ["m5.large"]
      k8s_labels       = { eks-nodegroup = "api"}
      iam_role_arn     = module.eks.worker_iam_role_arn
      capacity_type    = "ON_DEMAND"
      desired_capacity = 1
      min_capacity     = 1
      max_capacity     = 6
      subnets          = data.aws_subnet_ids.api.ids
    }
  }

  depends_on = [ aws_iam_role.admin, aws_iam_role.viewer ]

}
