resource "kubernetes_namespace" "istio" {
  count = var.create_istio ? 1 : 0
  metadata {
    name = "istio-system"
  }
}

resource "null_resource" "istio_operator" {
  count = var.create_istio ? 1 : 0

  provisioner "local-exec" {
    command = "istioctl manifest apply -f ${var.istio_manifest_filepath} -y"
    environment = {
      KUBECONFIG  = var.kubeconfig_path
      # AWS_PROFILE = var.context.aws_profile
    }
  }

  depends_on = [ kubernetes_namespace.istio ]

}