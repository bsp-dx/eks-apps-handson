module "label" {
  source = "../module/tfmodule-context"
  context = {
    aws_profile  = "terran"
    region       = "ap-northeast-2"
    region_alias = "an2"
    project      = "mydemo"
    environment  = "Demo"
    env_alias    = "d"
    owner        = "dx@bespinglobal.com"
    team_name    = "Devops Transformation"
    team         = "DX"
    cost_center  = "20211210"
    domain       = "simitsme.ml"
    pri_domain   = "mydemo.in"
  }
}

output "context" {
  value = module.label.context
}

output "name_prefix" {
  value = module.label.name_prefix
}

output "vpc_name" {
  value = module.label.vpc_name
}

output "eks_name" {
  value = module.label.eks_name
}

output "tags" {
  value = module.label.tags
}

output "region" {
  value = module.label.region
}

output "region_alias" {
  value = module.label.region_alias
}

output "project" {
  value = module.label.project
}

output "environment" {
  value = module.label.environment
}

output "env_alias" {
  value = module.label.env_alias
}

output "owner" {
  value = module.label.owner
}

output "team" {
  value = module.label.team
}

output "cost_center" {
  value = module.label.cost_center
}

output "domain" {
  value = module.label.domain
}

output "pri_domain" {
  value = module.label.pri_domain
}
