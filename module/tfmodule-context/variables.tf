variable "context" {
  type = object({
    region       = string # describe default region to create a resource from aws
    region_alias = string # region alias or AWS
    project      = string # project name is usally account's project name or platform name
    environment  = string # Runtime Environment such as develop, stage, production
    env_alias    = string # Runtime Environment such as develop, stage, production
    owner        = string # project owner
    team         = string # Team name of Devops Transformation
    cost_center  = number # Cost Center
    domain       = string # public toolchain domain name (ex, tools.customer.co.kr)
    pri_domain   = string # private domain name (ex, tools.customer.co.kr)
  })
}

locals {
  name_prefix = format("%s-%s%s", var.context.project, var.context.region_alias, var.context.env_alias)
  tags        = {
    Project     = var.context.project
    Environment = var.context.environment
    Team        = var.context.team
    Owner       = var.context.owner
  }
}

#locals {
#  aws_account_id        = data.aws_caller_identity.current.account_id
#  name_prefix           = format("%s-%s%s", var.context.project, var.context.region_alias, var.context.env_alias)
#  cluster_name          = format("%s-eks", local.name_prefix)
#  iam_mfa_policy        = format("%sMFAPolicy", var.context.project)
#  iam_admin_policy      = format("%sAdminPolicy", var.context.project)
#  iam_eks_admin_role    = format("%sEksAdminRole", var.context.project)
#  iam_eks_admin_policy  = format("%sEksAdminPolicy", var.context.project)
#  iam_eks_viewer_role   = format("%sEksViewerRole", var.context.project)
#  iam_eks_viewer_policy = format("%sEksViewerPolicy", var.context.project)
#  iam_eks_ec2_role      = format("%sEksEC2Role", var.context.project)
#  iam_eks_ec2_profile   = format("%sEksEC2Profile", var.context.project)
#}
