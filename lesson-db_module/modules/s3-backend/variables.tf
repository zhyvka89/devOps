variable "bucket_name" {
  description = "S3 bucket for Terraform state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table for Terraform state locking"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}
