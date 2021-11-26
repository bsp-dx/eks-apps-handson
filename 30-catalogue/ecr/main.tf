module "ctx" {
  source = "../../context"
}

module "ecr" {
  source = "../../module/tfmodule-aws-ecr"

  image_names          = ["sample-golang-service", "sample-spring-boot-service"]
  principals_full      = ["arn:aws:iam::827519537363:user/terran@bespinglobal.com"]
  principals_readonly  = ["*"]
  scan_images_on_push  = true
  image_tag_mutability = "IMMUTABLE"
  tags                 = module.ctx.tags
}