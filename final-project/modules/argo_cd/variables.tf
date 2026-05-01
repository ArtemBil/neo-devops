variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "Base64-encoded CA certificate for the EKS cluster"
  type        = string
}

variable "cluster_auth_token" {
  description = "Authentication token for the EKS cluster"
  type        = string
  sensitive   = true
}

variable "namespace" {
  description = "Namespace where Argo CD will be installed"
  type        = string
}

variable "chart_version" {
  description = "Version of the Argo CD Helm chart"
  type        = string
}

variable "gitops_repository_url" {
  description = "Git repository URL watched by Argo CD"
  type        = string
}

variable "gitops_repository_branch" {
  description = "Git branch watched by Argo CD"
  type        = string
}

variable "gitops_repository_name" {
  description = "Logical repository name in Argo CD repo config"
  type        = string
}

variable "gitops_chart_path" {
  description = "Path to the Helm chart inside the Git repository"
  type        = string
}

variable "gitops_repository_username" {
  description = "Optional Git repository username"
  type        = string
  sensitive   = true
}

variable "gitops_repository_password" {
  description = "Optional Git repository password or token"
  type        = string
  sensitive   = true
}

variable "django_release_name" {
  description = "Application name used in Argo CD"
  type        = string
}

variable "destination_namespace" {
  description = "Target namespace for the Django application"
  type        = string
}
