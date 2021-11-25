module "istio" {
  source = "./modules/istio"

  create_istio            = var.create_eks && var.enable_istio ? true : false
  context                 = var.context
  kubeconfig_path         = concat(local_file.kubeconfig.*.filename, [""])[0]
  oidc_provider_arn       = concat(aws_iam_openid_connect_provider.oidc_provider[*].arn, [""])[0]
  cert_manager_filepath   = var.cert_manager_filepath
  alb_controller_filepath = var.alb_controller_filepath
  istio_manifest_filepath = var.istio_manifest_filepath

  depends_on = [
    aws_eks_cluster.this
  ]

}
