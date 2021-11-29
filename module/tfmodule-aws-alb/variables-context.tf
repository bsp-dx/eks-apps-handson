variable "context" {
  type = object({
    project     = string
    name_prefix = string
    domain      = string
    pri_domain  = string
    tags        = object({
      Project     = string
      Environment = string
      Team        = string
      Owner       = string
    })
  })
}
