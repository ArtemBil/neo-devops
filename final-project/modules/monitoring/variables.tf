variable "cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "Base64-encoded EKS cluster CA certificate"
  type        = string
}

variable "cluster_auth_token" {
  description = "Authentication token for the EKS cluster"
  type        = string
  sensitive   = true
}

variable "namespace" {
  description = "Namespace where monitoring components are installed"
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "Helm chart version for kube-prometheus-stack"
  type        = string
  default     = "58.5.3"
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
  default     = "change-me-grafana"
}
