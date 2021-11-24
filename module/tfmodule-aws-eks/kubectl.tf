resource "local_file" "kubeconfig" {
  count = var.write_kubeconfig && var.create_eks ? 1 : 0

  content              = local.kubeconfig
  filename             = length(var.kubeconfig_output_path) < 2 ? format("%s/%s", pathexpand("~/.kube"), local.cluster_name) : var.kubeconfig_output_path
  file_permission      = var.kubeconfig_file_permission
  directory_permission = "0755"
}
