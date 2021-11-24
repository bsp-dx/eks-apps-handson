variable "enable_istio" {
  description = "Install Istio and Istio Ingress Controller"
  type = bool
  default = true
}

variable "istio_manifest_filepath" {
  description = "Istio Operator Manifest template file path"
  type        = string
  default     = null
}