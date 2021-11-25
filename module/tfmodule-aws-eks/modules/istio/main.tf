locals {
  cert_manager_templatefile = var.cert_manager_filepath == null   ? "${path.module}/templates/kubernetes/cert-manager-1.6.1.yaml" : var.cert_manager_filepath
  cert_manager_targetfile = "${path.module}/kubernetes/istio/cert-manager.yaml"
  alb_controller_filepath   = var.cert_manager_filepath == null   ? "${path.module}/templates/kubernetes/cert-manager-1.6.1.yaml.yaml" : var.cert_manager_filepath
  istio_manifest_filepath   = var.istio_manifest_filepath == null ? "${path.module}/templates/kubernetes/istio-manifests-minimal.yaml" : var.istio_manifest_filepath
}

resource "null_resource" "cp_template_files" {
  provisioner "local-exec" {
    command = <<EOT
cp ${local.cert_manager_templatefile} ${path.module}/kubernetes/istio/cert-manager.yaml
EOT
  }
}

resource "kubectl_manifest" "cert_manager" {
  yaml_body  = file("")
  depends_on = [
    null_resource.cp_template_files
  ]
}


/*
  ## 플러그인 설치 순서
  1. OIDC IAM Role
  2. cert-manager
  3. aws-load-balancer-controller
  4. Istio core
  5. Istio ingress-gateway NLB
  6. Istio ingress-controller ALB
*/
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

resource "kubernetes_manifest" "istio_namespace" {
  count    = var.create_istio ? 1 : 0
  metadata {
    name = "istio-system"
  }
  manifest = ""
}
