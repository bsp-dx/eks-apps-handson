resource "aws_iam_policy" "allow_ecr_on_node_groups" {
  count = var.enable_ecr_access_policy ? 1 : 0
  name = "AllowECROnNodeGroupPolicy"
  description = "Policy that allows pull images from ECR repositories"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "allow_ecr_on_node_groups" {
  count = var.enable_ecr_access_policy ? 1 : 0
  role       = local.worker_iam_role_name
  policy_arn = aws_iam_policy.allow_ecr_on_node_groups[0].arn
}