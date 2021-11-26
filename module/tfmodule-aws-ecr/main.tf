locals {
  create_ecr          = length(compact(var.image_names)) > 0 ? true : false
  create_ecr_readonly = local.create_ecr && length(var.principals_readonly) > 0  ? true : false
  create_ecr_full     = local.create_ecr && length(var.principals_full) > 0  ? true : false
}

resource "aws_ecr_repository" "this" {
  for_each             = toset(var.image_names)
  name                 = each.value
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_images_on_push
  }

  tags = merge(var.tags, { Name = each.value })
}

resource "aws_ecr_repository_policy" "this" {
  for_each   = toset(var.image_names)
  repository = aws_ecr_repository.this[each.value].name
  policy     = join("", data.aws_iam_policy_document.this.*.json)
}

data "aws_iam_policy_document" "ecr_readonly" {
  count = local.create_ecr  ? 1 : 0

  statement {
    sid    = "ReadonlyAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.principals_readonly
    }

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:ListTagsForResource",
    ]
  }
}


data "aws_iam_policy_document" "ecr_full" {
  count = local.create_ecr ? 1 : 0

  statement {
    sid    = "FullAccess"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = var.principals_full
    }
    actions = ["ecr:*"]
  }
}

data "aws_iam_policy_document" "empty" {
  count = local.create_ecr ? 1 : 0
}

data "aws_iam_policy_document" "this" {
  count         = local.create_ecr ? 1 : 0
  source_json   = local.create_ecr_readonly ? join("", [data.aws_iam_policy_document.ecr_readonly[0].json]) : join("", [
    data.aws_iam_policy_document.empty[0].json
  ])
  override_json = local.create_ecr_full ? join("", [data.aws_iam_policy_document.ecr_full[0].json]) : join("", [
    data.aws_iam_policy_document.empty[0].json
  ])
}
