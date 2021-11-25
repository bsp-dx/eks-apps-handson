module "istio" {
  source = "./modules/istio"

  create_istio            = var.create_eks && var.enable_istio ? true : false
  context                 = var.context
  cluster_name            = local.cluster_name
  kubernetes_target       = var.kubernetes_target
  kubeconfig_path         = concat(local_file.kubeconfig.*.filename, [""])[0]
  oidc_role_arn           = coalescelist(aws_iam_role.oidc.*.arn, [""])[0]
  cert_manager_filepath   = var.cert_manager_filepath
  alb_controller_filepath = var.alb_controller_filepath
  istio_manifest_filepath = var.istio_manifest_filepath

  depends_on = [
    data.http.wait_for_cluster
  ]

}
