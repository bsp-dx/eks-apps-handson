locals {
  istio_manifest_filepath = var.istio_manifest_filepath == null ? "${path.module}/templates/kubernetes/istio-manifests-minimal.yaml" : var.istio_manifest_filepath
}

resource "kubernetes_namespace" "istio_namespace" {
  count = var.create_istio ? 1 : 0
  metadata {
    name = "istio-system"
  }
}

resource "null_resource" "istio_manifest" {
  count = var.create_istio ? 1 : 0

  provisioner "local-exec" {
    command     = "istioctl manifest apply -f ${local.istio_manifest_filepath} -y"
    environment = {
      KUBECONFIG = var.kubeconfig_path
      # AWS_PROFILE = var.context.aws_profile
    }
  }

  depends_on = [kubernetes_namespace.istio_namespace]

}