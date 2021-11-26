variable "tags" {
  type = object({
    Project     = string
    Environment = string
    Team        = string
    Owner       = string
  })
}
