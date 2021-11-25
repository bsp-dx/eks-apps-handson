variable "create_istio" {
  description = "Create Istio Controller"
  type        = bool
  default     = false
}

variable "context" {
  type = object({
    aws_profile  = string # describe a specifc profile to access a aws cli
    region      = string # describe default region to create a resource from aws
    project     = string # project name is usally account's project name or platform name
    name_prefix = string # resource name prefix
    environment = string # Runtime Environment such as develop, stage, production
    team        = string # Team name of Devops Transformation
    owner       = string # project owner
    cost_center = number # Cost Center
  })
}

variable "cluster_name" {
  description = "kubernetes cluster name"
  type        = string
}

variable "kubeconfig_path" {
  description = "kubeconfig filepath"
  type        = string
}

variable "kubernetes_target" {
  description = "Kubernetes resource filepath"
  type        = string
}

variable "oidc_role_arn" {
  description = "OIDC IAM Role arn"
  type        = string
}

variable "alb_controller_filepath" {
  description = "AWS Load Balancer Controller template file path that manages AWS Elastic Load Balancers for a Kubernetes cluster."
  type        = string
}

variable "cert_manager_filepath" {
  description = "Kubernetes Certificate Management file path"
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

#variable "oidc_provider_arn" {
#  type        = string
#  description = "The ARN of the EKS OIDC Provider."
#}


