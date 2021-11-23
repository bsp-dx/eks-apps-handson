variable "iam_admin_role_arn" {
  description = "EKS 클러스터의 Admin 권한과 매핑하게 될 IAM 의 Admin Role ARN"
  type = string
  default = ""
}

variable "iam_viewer_role_arn" {
  description = "EKS 클러스터의 Viewer 권한과 매핑하게 될 IAM 의 Viewer Role ARN"
  type = string
  default = ""
}

variable "enable_ecr_access_policy" {
  description = "Policy that allows pull images from ECR repositories"
  type = bool
  default = true
}

