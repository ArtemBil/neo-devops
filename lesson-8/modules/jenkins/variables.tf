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
  description = "Namespace where Jenkins will be installed"
  type        = string
}

variable "chart_version" {
  description = "Version of the Jenkins Helm chart"
  type        = string
}

variable "admin_user" {
  description = "Jenkins admin username"
  type        = string
}

variable "admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
}

variable "github_credentials_id" {
  description = "Jenkins credentials ID for GitHub access"
  type        = string
}

variable "github_repository_url" {
  description = "GitOps repository URL that Jenkins will update"
  type        = string
}

variable "github_branch" {
  description = "GitOps repository branch that Jenkins will update"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL used by the Jenkins pipeline"
  type        = string
}

variable "aws_region" {
  description = "AWS region used by the Jenkins pipeline"
  type        = string
}
