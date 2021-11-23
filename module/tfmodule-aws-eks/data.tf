data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "workers_assume_role_policy" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = [local.ec2_principal]
    }
  }
}

data "aws_ami" "eks_worker" {
  count = contains(local.worker_groups_platforms, "linux") ? 1 : 0

  filter {
    name   = "name"
    values = [local.worker_ami_name_filter]
  }

  most_recent = true

  owners = [var.worker_ami_owner_id]
}

data "aws_ami" "eks_worker_windows" {
  count = contains(local.worker_groups_platforms, "windows") ? 1 : 0

  filter {
    name   = "name"
    values = [local.worker_ami_name_filter_windows]
  }

  filter {
    name   = "platform"
    values = ["windows"]
  }

  most_recent = true

  owners = [var.worker_ami_owner_id_windows]
}

data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    sid = "EKSClusterAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "http" "wait_for_cluster" {
  count = var.create_eks && var.manage_aws_auth ? 1 : 0

  url            = format("%s/healthz", aws_eks_cluster.this[0].endpoint)
  ca_certificate = base64decode(local.cluster_auth_base64)
  timeout        = var.wait_for_cluster_timeout

  depends_on = [
    aws_eks_cluster.this,
    aws_security_group_rule.cluster_private_access_sg_source,
    aws_security_group_rule.cluster_private_access_cidrs_source,
  ]
}
