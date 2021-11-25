output "oidc_role_arn" {
  description = "EKS OIDC Role arn to provide authentication for kubernetes resources can control to AWS Resources like ELB, EC2"
  value = coalescelist(aws_iam_role.oidc.*.arn, [""])[0]
}


#output "istio_operator_id" {
#  value = null_resource.istio_operator.*.id
#}
#
#output "ingress_alb_id" {
#  value = null_resource.ingress_alb.*.id
#}
#
#output "ingress_controller_id" {
#  value = null_resource.ingress_controller.*.id
#}
#
#output "istio_gateway_health_check_id" {
#  value = null_resource.istio_gateway_health_check.id
#}
#
#output "ingress_controller_health_check_id" {
#  value = null_resource.ingress_controller_health_check.id
#}
