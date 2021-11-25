# Istio 구성 순서
#   1. OIDC IAM Role
#   2. cert-manager
#   3. aws-load-balancer-controller
#   4. Istio manifest (core / ingress-gateway)
#   5. Istio ingress-controller ALB
#
locals {
  istio_filepath                = "${var.kubernetes_target}/istio"
  cert_manager_srcfile          = var.cert_manager_filepath == null   ? "${path.module}/templates/kubernetes/cert-manager-1.6.1.yaml" : var.cert_manager_filepath
  cert_manager_targetfile       = "${local.istio_filepath}/cert-manager.yaml"
  alb_controller_srcfile        = var.alb_controller_filepath == null ? "${path.module}/templates/kubernetes/alb-controller-2.3.0.yaml" : var.alb_controller_filepath
  alb_controller_targetfile     = "${local.istio_filepath}/alb-controller.yaml"
  istio_manifest_srcfile        = var.istio_manifest_filepath == null ? "${path.module}/templates/kubernetes/istio-manifest.yaml" : var.istio_manifest_filepath
  istio_manifest_targetfile     = "${local.istio_filepath}/istio-manifests.yaml"
  ingress_controller_srcfile    = var.ingress_controller_filepath == null ? "${path.module}/templates/kubernetes/ingress-controller.yaml" : var.ingress_controller_filepath
  ingress_controller_targetfile = "${local.istio_filepath}/ingress-controller.yaml"

  nlb_name          = "${var.context.name_prefix}-ingress-nlb"
  nlb_resource_tags = format("Name=%s,Project=%s,Environment=%s,Team=%s,Owner=%s", local.nlb_name, var.context.project, var.context.environment, var.context.team, var.context.owner)
  alb_name          = "${var.context.name_prefix}-ingress-alb"
  alb_resource_tags = format("Name=%s,Project=%s,Environment=%s,Team=%s,Owner=%s", local.alb_name, var.context.project, var.context.environment, var.context.team, var.context.owner)
}

resource "null_resource" "cert_manager_copy" {
  count = var.create_istio ? 1 : 0
  provisioner "local-exec" {
    command = "cp ${local.cert_manager_srcfile} ${local.cert_manager_targetfile}"
  }
}

resource "local_file" "alb_controller" {
  count             = var.create_istio ? 1 : 0
  sensitive_content = templatefile(local.alb_controller_srcfile, {
    cluster_name  = var.cluster_name
    oidc_role_arn = var.oidc_role_arn
  })
  filename          = local.alb_controller_targetfile
}

resource "local_file" "istio_manifest" {
  count             = var.create_istio ? 1 : 0
  sensitive_content = templatefile(local.istio_manifest_srcfile, {
    load_balancer_name = local.nlb_name
    resource_tags      = local.nlb_resource_tags
  })
  filename          = local.istio_manifest_targetfile
}

resource "local_file" "ingress_controller" {
  count             = var.create_istio ? 1 : 0
  sensitive_content = templatefile(local.istio_manifest_targetfile, {
    acm_certificate_arn = var.acm_certificate_arn
    public_security_group_id = "security_group_ids" # "${public_security_group_id},${worker_security_group_id}"
    load_balancer_name = local.alb_name
    resource_tags      = local.alb_resource_tags
  })
  filename          = local.istio_manifest_targetfile
}


output "alb_controller_filename" {
  value = local_file.alb_controller[0].filename
}

output "istio_manifest_filename" {
  value = local_file.istio_manifest[0].filename
}

output "ingress_controller_filename" {
  value = local_file.ingress_controller[0].filename
}

resource "null_resource" "cert_manager" {
  count = var.create_istio ? 1 : 0

  provisioner "local-exec" {
    command     = "kubectl apply -f ${local.cert_manager_targetfile}"
    environment = {
      AWS_PROFILE = var.context.aws_profile
      KUBECONFIG  = var.kubeconfig_path
    }
  }

  depends_on = [
    null_resource.cert_manager_copy
  ]
}

resource "null_resource" "cert_manager_health_check" {
  count = var.create_istio ? 1 : 0

  provisioner "local-exec" {
    command     = <<EOF
STAT="false"
while [ "$STAT" != "true" ]
do
  STAT=`kubectl get pod -n cert-manager -l app=cainjector -o jsonpath="{.items[0].status.containerStatuses[0].ready}"`; sleep 3;
done
EOF
    environment = {
      AWS_PROFILE = var.context.aws_profile
      KUBECONFIG  = var.kubeconfig_path
    }
  }

  depends_on = [null_resource.cert_manager]
}

resource "null_resource" "alb-controller" {
  count = var.create_istio ? 1 : 0

  provisioner "local-exec" {
    command     = "kubectl apply -f ${local.alb_controller_targetfile}"
    environment = {
      AWS_PROFILE = var.context.aws_profile
      KUBECONFIG  = var.kubeconfig_path
    }
  }
  depends_on = [local_file.alb_controller]
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
    command     = "istioctl manifest apply -f ${local.istio_manifest_targetfile} -y"
    environment = {
      AWS_PROFILE = var.context.aws_profile
      KUBECONFIG  = var.kubeconfig_path
    }
  }

  depends_on = [
    kubernetes_namespace.istio_namespace,
    local_file.istio_manifest,
    null_resource.cert_manager_health_check,
    null_resource.alb-controller
  ]
}

resource "null_resource" "ingress_controller" {
  count = var.create_istio ? 1 : 0

  provisioner "local-exec" {
    command     = "kubectl apply -f ${local.ingress_controller_targetfile}"
    environment = {
      AWS_PROFILE = var.context.aws_profile
      KUBECONFIG  = var.kubeconfig_path
    }
  }

  depends_on = [
    local_file.ingress_controller,
    null_resource.istio_manifest
  ]

}
