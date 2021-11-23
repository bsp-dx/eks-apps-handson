# Enable IAM Roles for EKS Service-Accounts (IRSA).

# The Root CA Thumbprint for an OpenID Connect Identity Provider is currently
# Being passed as a default value which is the same for all regions and
# Is valid until (Jun 28 17:39:16 2034 GMT).
# https://crt.sh/?q=9E99A48A9960B14926BB7F3B02E22DA2B0AB7280
# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
# https://github.com/terraform-providers/terraform-provider-aws/issues/10104

# Enable OpenID Connect Provider for EKS to enable IRSA
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  count = var.create_eks ? 1 : 0

  client_id_list  = local.client_id_list
  thumbprint_list = [var.eks_oidc_root_ca_thumbprint]
  url             = local.cluster_oidc_issuer_url

  tags = merge(local.tags,  {Name = "${local.cluster_name}-irsa"},)
}
