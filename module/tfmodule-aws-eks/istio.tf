module "istio" {
  source = "./modules/istio"

  create_istio      = var.create_eks && var.enable_istio ? true: false
  context           = var.context
  ingress_config    = {

  }
  oidc_provider_arn = concat(aws_iam_openid_connect_provider.oidc_provider[*].arn, [""])[0]
}
