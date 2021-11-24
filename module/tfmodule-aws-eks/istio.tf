module "istio" {
  source = "./modules/istio"

  create_istio            = var.create_eks && var.enable_istio ? true : false
  context                 = var.context
  kubeconfig_path         = concat(local_file.kubeconfig.*.filename, [""])[0]
  oidc_provider_arn       = concat(aws_iam_openid_connect_provider.oidc_provider[*].arn, [""])[0]
  istio_manifest_filepath = var.istio_manifest_filepath == null ? "${path.module}/templates/kubernetes/istio-manifests-default.yaml" : var.istio_manifest_filepath

}
