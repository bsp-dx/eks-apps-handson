### ----- EKS Module -----

output "kubeconfig_filename" {
  value = module.eks.kubeconfig_filename
}

output "eks_endpoint" {
  value = local.eks_endpoint
}

output "eks_auth_token" {
  value = local.eks_auth_token
  sensitive = true
}

output "eks_ca_certificate" {
  value = local.eks_ca_certificate
}

output "oidc_role_arn" {
  value = module.eks.oidc_role_arn
}