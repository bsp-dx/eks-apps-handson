# AWSLoadBalancerControllerIAMPolicy
resource "aws_iam_policy" "alb_ingress_controller" {
  count  = local.enabled_istio ? 1 : 0
  name   = "ALBIngressControllerPolicy"
  policy = file("${path.module}/policy/ALBIngressControllerPolicy.json")
}

resource "aws_iam_policy" "ec2_asg" {
  count  = local.enabled_istio ? 1 : 0
  name   = "AWSEC2AutoscalerPolicy"
  policy = file("${path.module}/policy/AWSEC2AutoscalerPolicy.json")
}

resource "aws_iam_role" "oidc" {
  count = local.enabled_istio ? 1 : 0
  name  = format("%sEKSOidcRole", var.context.project)

  assume_role_policy = templatefile("${path.module}/policy/AssumeRoleOIDCPolicy.json", {
    oidc_provider_arn = var.oidc_provider_arn
    oidc_provider_id  = element(split("/", var.oidc_provider_arn), 3)
    aws_region        = var.context.region
  })

  managed_policy_arns = [
    aws_iam_policy.alb_ingress_controller.*.arn[0],
    aws_iam_policy.ec2_asg.*.arn[0]
  ]
}