output "registry_id" {
  value       = local.create_ecr ? aws_ecr_repository.this[var.image_names[0]].registry_id : ""
  description = "Registry ID"
}

output "repository_name" {
  value       = local.create_ecr ? aws_ecr_repository.this[var.image_names[0]].name : ""
  description = "Name of first repository created"
}

output "repository_url" {
  value       = local.create_ecr ? aws_ecr_repository.this[var.image_names[0]].repository_url : ""
  description = "URL of first repository created"
}

output "repository_arn" {
  value       = local.create_ecr ? aws_ecr_repository.this[var.image_names[0]].arn : ""
  description = "ARN of first repository created"
}

output "repository_url_map" {
  value       = zipmap(values(aws_ecr_repository.this)[*].name, values(aws_ecr_repository.this)[*].repository_url)
  description = "Map of repository names to repository URLs"
}

output "repository_arn_map" {
  value       = zipmap(values(aws_ecr_repository.this)[*].name, values(aws_ecr_repository.this)[*].arn)
  description = "Map of repository names to repository ARNs"
}