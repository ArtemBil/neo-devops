output "namespace" {
  description = "Namespace where monitoring components are installed"
  value       = kubernetes_namespace.this.metadata[0].name
}

output "grafana_service_name" {
  description = "Grafana service name"
  value       = "kube-prometheus-stack-grafana"
}

output "prometheus_service_name" {
  description = "Prometheus service name"
  value       = "kube-prometheus-stack-prometheus"
}
