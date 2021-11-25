variable "context" {
  type = object({
    aws_profile  = string # describe a specifc profile to access a aws cli
    region       = string # describe default region to create a resource from aws
    region_alias = string # region alias or AWS
    project      = string # project name is usally account's project name or platform name
    environment  = string # Runtime Environment such as develop, stage, production
    env_alias    = string # Runtime Environment such as develop, stage, production
    owner        = string # project owner
    team         = string # Team name of Devops Transformation
    cost_center  = number # Cost Center
    domain       = string # public domain name
    name_prefix  = string # resource name prefix
    tags         = object({
      Project     = string
      Environment = string
      Team        = string
      Owner       = string
    })
  })
  /*
  default = {
    region                  = null
    region_alias            = null
    project                 = null
    environment             = "dev"
    env_alias               = "d"
    owner                   = null
    team                    = null
    cost_center             = null
    name_prefix = null
    tags = {}
  }
  */
}