variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_ca" {
  type = string
}

variable "kubeconfig" {
  description = "Path to kubeconfig file"
  type        = string
}

variable "oidc_provider_arn" {
  description = "Description"
  type        = string
}

variable "oidc_provider_url" {
  description = "Description"
  type        = string
}

