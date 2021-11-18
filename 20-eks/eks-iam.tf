# MFA 활성화 정책 생성
resource "aws_iam_policy" "mfa_enabled" {
  name = local.iam_mfa_policy
  path = "/"

  policy = templatefile("${path.module}/policy/ForcedMFAPolicy.json", {})
}

# EKS Admin Policy
resource "aws_iam_policy" "admin" {
  name = local.iam_admin_policy
  path = "/"

  policy = templatefile("${path.module}/policy/AssumeRoleAdminPolicy.json", {
    account_id = local.aws_account_id
    role_name  = local.iam_eks_admin_policy
  })
}

# IAM Admin Role for EKS (TO-BE data-source)
resource "aws_iam_role" "admin" {
  name = local.iam_eks_admin_role

  assume_role_policy = templatefile("${path.module}/policy/AssumeRoleEC2Policy.json", {
    account_id = local.aws_account_id
  })

  managed_policy_arns = [
    aws_iam_policy.admin.arn,
    aws_iam_policy.mfa_enabled.arn
  ]
}


# IAM Viewer Role for EKS (TO-BE data-source)
resource "aws_iam_role" "viewer" {
  name = local.iam_eks_viewer_role

  assume_role_policy = templatefile("${path.module}/policy/AssumeRoleEC2Policy.json", {
    account_id = local.aws_account_id
  })

  managed_policy_arns = [
    aws_iam_policy.viewer.arn,
    aws_iam_policy.mfa_enabled.arn
  ]

}

resource "aws_iam_policy" "viewer" {
  name = local.iam_eks_viewer_policy
  path = "/"

  policy = templatefile("${path.module}/policy/AssumeRoleViewerPolicy.json", {
    account_id = local.aws_account_id
    role_name  = local.iam_eks_viewer_policy
  })
}
