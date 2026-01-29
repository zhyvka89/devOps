output "repository_url" {
  description = "ECR repository URL"
  value       = data.aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  description = "ECR repository ARN"
  value       = data.aws_ecr_repository.this.arn
}
