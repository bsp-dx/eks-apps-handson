variable "image_names" {
  description = "List of Docker image names, used as AWS ECR private repository names"
  type        = list(string)
  default     = []
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`"
  type        = string
  default     = "IMMUTABLE"
}

variable "enable_lifecycle_policy" {
  description = "Set to false to prevent the module from adding any lifecycle policies to any repositories"
  type        = bool
  default     = true
}

variable "scan_images_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not (false)"
  type        = bool
  default     = true
}

variable "principals_readonly" {
  description = "Principal ARNs to provide with readonly access to the ECR"
  type        = list(string)
  default     = []
}

variable "principals_full" {
  description = "Principal ARNs to provide with read & write access to the ECR"
  type        = list(string)
  default     = ["*"]
}