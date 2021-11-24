variable "create_istio" {
  description = "Create Istio Controller"
  type        = bool
  default     = false
}

variable "kubeconfig_path" {
  description = "kubeconfig filepath"
  type        = string
}

variable "istio_manifest_filepath" {
  description = "Istio Operator Manifest template file path"
  type        = string
}


#variable "project" {
#  type        = string
#  description = "project name is usally account's project name or platform name"
#}
#
#variable "region" {
#  type        = string
#  description = "default region to create a resource from aws"
#}

variable "oidc_provider_arn" {
  type        = string
  description = "The ARN of the EKS OIDC Provider."
}


variable "context" {
  type = object({
    region  = string # describe default region to create a resource from aws
    project = string # project name is usally account's project name or platform name
    #    environment             = string # Runtime Environment such as develop, stage, production
    #    env_alias               = string # Runtime Environment such as develop, stage, production
    #    owner                   = string # project owner
    #    team                    = string # Team name of Devops Transformation
    #    cost_center             = number # Cost Center
  })
}
#
#variable "enable_istio" {
#  description = "Install Istio and Istio Ingress Controller"
#  type = bool
#  default = true
#}
#
#variable "istio_depends_on" {
#  description = "List of references to other resources this submodule depends on"
#  type        = any
#  default     = null
#}
#
#variable "kubeconfig_path" {
#  description = "KUBECONFIG PATH"
#  type = string
#}
#
#variable "istio_operator_yaml" {
#  description = "istio operator yaml path"
#  type = string
#  # IE: "{terraform_module_basepath}/kubernetes/istio/istio-operator.yaml"
#}
#
#variable "istio_ingress_yaml" {
#  description = "istio ingress kubernetes yaml path"
#  type = string
#  # IE: "{terraform_module_basepath}/kubernetes/istio/istio-ingress.yaml"
#}
#
#variable "istio_ingress_controller_yaml" {
#  description = "istio ingress controller yaml path"
#  type = string
#  # IE: "{terraform_module_basepath}/kubernetes/istio/istio-ingress-controller.yaml"
#}
#
#variable "cert_manager_webhook_yaml" {
#  description = "ingress controller cert manager webhook yaml path"
#  type = string
#  # default = "./templates/istio/cert-manager-webhook.yaml"
#}
#
#locals {
#  name_prefix = format("%s-%s%s", var.context.project, var.context.region_alias, var.context.env_alias)
#  cluster_name = format("%s-eks", local.name_prefix)
#}
