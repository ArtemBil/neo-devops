output "jenkins_url" {
  description = "Internal Jenkins service URL"
  value       = "http://jenkins.${var.namespace}.svc.cluster.local:8080"
}

output "admin_user" {
  description = "Jenkins admin username"
  value       = var.admin_user
}
