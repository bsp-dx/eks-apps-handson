module "istio" {
  source = "./modules/istio"

  create_istio      = true
  context           = var.context
  ingress_config    = {

  }
  oidc_provider_arn = concat(aws_iam_openid_connect_provider.oidc_provider[*].arn, [""])[0]
}
