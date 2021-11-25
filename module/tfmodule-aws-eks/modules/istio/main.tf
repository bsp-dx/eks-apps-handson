locals {
  istio_filepath            = "${var.kubernetes_target}/istio"
  cert_manager_srcfile      = var.cert_manager_filepath == null   ? "${path.module}/templates/kubernetes/cert-manager-1.6.1.yaml" : var.cert_manager_filepath
  cert_manager_targetfile   = "${local.istio_filepath}/cert-manager.yaml"
  alb_controller_srcfile    = var.alb_controller_filepath == null ? "${path.module}/templates/kubernetes/alb-controller-2.3.0.yaml" : var.alb_controller_filepath
  alb_controller_targetfile = "${local.istio_filepath}/alb-controller.yaml"
  istio_manifest_srcfile    = var.istio_manifest_filepath == null ? "${path.module}/templates/kubernetes/istio-manifest.yaml" : var.istio_manifest_filepath
  istio_manifest_targetfile = "${local.istio_filepath}/istio-manifests.yaml"

  load_balancer_name = "${var.context.name_prefix}-ingress-nlb"
  resource_tags      = format("Name=%s,Project=%s,Environment=%s,Team=%s,Owner=%s",
  local.load_balancer_name, var.context.project, var.context.environment, var.context.team, var.context.owner)
}

resource "local_file" "kubernetes" {
  count = var.create_istio ? 1 : 0

  content  = "{'foo': 'bar'}"
  filename = "${local.istio_filepath}/foo.json"
}

resource "null_resource" "copy_templates" {
  count = var.create_istio ? 1 : 0

  provisioner "local-exec" {
    command     = <<EOT

cp ${local.cert_manager_srcfile} ${local.cert_manager_targetfile}
cp ${local.alb_controller_srcfile} ${local.alb_controller_targetfile}
cp ${local.istio_manifest_srcfile} ${local.istio_manifest_targetfile}

sed -i'' -e 's#{{oidc_role_arn}}#${var.oidc_role_arn}#g' ${local.alb_controller_targetfile}
sed -i'' -e 's#{{cluster_name}}#${var.cluster_name}#g' ${local.alb_controller_targetfile}

sed -i'' -e 's#{{load_balancer_name}}#${local.load_balancer_name}#g' ${local.istio_manifest_targetfile}
sed -i'' -e 's#{{resource_tags}}#${local.resource_tags}#g' ${local.istio_manifest_targetfile}

sleep 1

EOT
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [
    local_file.kubernetes
  ]
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
    null_resource.copy_templates
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
  depends_on = [null_resource.copy_templates]
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
    null_resource.cert_manager_health_check,
    null_resource.alb-controller
  ]

}


/*
  ## 플러그인 설치 순서
  1. OIDC IAM Role
  2. cert-manager
  3. aws-load-balancer-controller
  4. Istio manifest (core / ingress-gateway)
  6. Istio ingress-controller ALB
*/

