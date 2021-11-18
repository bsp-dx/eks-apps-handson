terraform {
  required_version = ">= 1.0.10"

  required_providers {
    aws        = ">= 3.65.0"
    local      = ">= 1.4"
    null       = ">= 2.1"
    template   = ">= 2.1"
    random     = ">= 2.1"
    kubernetes = ">= 2.1.0"
  }
}
