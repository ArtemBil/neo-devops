output "argocd_server_url" {
  description = "Internal Argo CD server URL"
  value       = "http://argo-cd-argocd-server.${var.namespace}.svc.cluster.local"
}

output "argocd_initial_admin_password" {
  description = "Initial Argo CD admin password"
  value       = try(base64decode(data.kubernetes_secret_v1.argocd_admin.data.password), "")
  sensitive   = true
}
