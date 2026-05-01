resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "jenkins" {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = var.chart_version
  namespace        = kubernetes_namespace.this.metadata[0].name
  create_namespace = false

  values = [
    templatefile("${path.module}/values.yaml", {
      admin_user            = var.admin_user
      admin_password        = var.admin_password
      github_credentials_id = var.github_credentials_id
      github_repository_url = var.github_repository_url
      github_branch         = var.github_branch
      jenkinsfile_path      = var.jenkinsfile_path
      ecr_repository_url    = var.ecr_repository_url
      aws_region            = var.aws_region
    })
  ]

  depends_on = [kubernetes_namespace.this]
}
