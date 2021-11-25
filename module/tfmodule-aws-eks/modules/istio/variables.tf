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

variable "acm_certificate_arn" {
  description = "ALB Ingress Controller ACM Certification ARN"
  type        = string
}

variable "security_group_ids" {
  description = "SecurityGroup id list for ALB Ingress Controller"
  type        = string
  # "sg-012301238,sg-3nkdfsh23423,sg-4234234"
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

variable "ingress_controller_filepath" {
  description = "AWS ALB Controller template file path"
  type        = string
}