variable "enable_istio" {
  description = "Install Istio and Istio Ingress Controller"
  type        = bool
  default     = true
}

variable "acm_certificate_arn" {
  description = "ALB Ingress Controller ACM Certification ARN"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "SecurityGroup list for ALB Ingress Controller"
  type        = list(string)
  default     = []
}

variable "kubernetes_target" {
  description = "Kubernetes resource filepath"
  type        = string
  default     = "./target/kubernetes"
}

variable "cert_manager_filepath" {
  description = "Kubernetes Certificate Management file path"
  type        = string
  default     = null
}

variable "alb_controller_filepath" {
  description = "AWS Load Balancer Controller template file path that manages AWS Elastic Load Balancers for a Kubernetes cluster."
  type        = string
  default     = null
}

variable "istio_manifest_filepath" {
  description = "Istio Operator Manifest template file path"
  type        = string
  default     = null
}

variable "ingress_controller_filepath" {
  description = "AWS ALB Controller template file path"
  type        = string
  default     = null
}
