resource "aws_iam_policy" "alb_ingress_controller" {
  name   = "ALBIngressControllerPolicy"
  # AWSLoadBalancerControllerIAMPolicy
  policy = file("${path.module}/policy/ALBIngressControllerPolicy.json")
}

resource "aws_iam_policy" "ec2_asg" {
  name   = "AWSEC2AutoscalerPolicy"
  policy = file("${path.module}/policy/AWSEC2AutoscalerPolicy.json")
}

resource "aws_iam_role" "oidc" {
  name  = format("%sEKSOidcRole", var.context.project)

  assume_role_policy = templatefile("${path.module}/policy/AssumeRoleOIDCPolicy.json", {
    oidc_provider_arn = local.oidc_provider_arn
    oidc_provider_id  = element(split("/", local.oidc_provider_arn), 3)
    aws_region        = var.context.region
  })

  managed_policy_arns = [
    aws_iam_policy.alb_ingress_controller.*.arn[0],
    aws_iam_policy.ec2_asg.*.arn[0]
  ]
}

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