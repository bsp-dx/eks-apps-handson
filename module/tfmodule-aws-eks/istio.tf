module "istio" {
  source = "./modules/istio"

  create_istio                = var.create_eks && var.enable_istio ? true : false
  context                     = var.context
  cluster_name                = local.cluster_name
  acm_certificate_arn         = var.acm_certificate_arn == null ? data.aws_acm_certificate.this.arn : var.acm_certificate_arn
  security_group_ids          = join(",", var.security_group_ids, coalescelist(aws_security_group.workers.*.id, [""]))
  kubernetes_target           = var.kubernetes_target
  kubeconfig_path             = concat(local_file.kubeconfig.*.filename, [""])[0]
  oidc_role_arn               = coalescelist(aws_iam_role.oidc.*.arn, [""])[0]
  cert_manager_filepath       = var.cert_manager_filepath
  alb_controller_filepath     = var.alb_controller_filepath
  istio_manifest_filepath     = var.istio_manifest_filepath
  ingress_controller_filepath = var.ingress_controller_filepath

  depends_on = [
    data.http.wait_for_cluster
  ]

}
