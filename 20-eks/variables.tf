variable "namespace" {
  description = "kubernetes namespace"
  type        = string
}

locals {
  aws_account_id        = data.aws_caller_identity.current.account_id
  project               = module.ctx.project
  name_prefix           = module.ctx.name_prefix
  iam_mfa_policy        = format("%sMFAForcedPolicy", local.project)
  iam_eks_admin_role    = format("%sEKSAdminRole", local.project)
  iam_eks_admin_policy  = format("%sAssumeRoleAdminPolicy", local.project)
  iam_eks_viewer_role   = format("%sEKSViewerRole", local.project)
  iam_eks_viewer_policy = format("%sAssumeRoleViewerPolicy", local.project)
#  iam_eks_ec2_role      = format("%sEKSEC2Role", local.project)
#  iam_eks_ec2_profile   = format("%sEKSEC2Profile", local.project)
}
