resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argo_cd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  namespace        = kubernetes_namespace.this.metadata[0].name
  create_namespace = false

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [kubernetes_namespace.this]
}

resource "kubernetes_namespace" "django" {
  metadata {
    name = var.destination_namespace
  }
}

resource "helm_release" "argocd_apps" {
  name             = "argocd-apps"
  chart            = "${path.module}/charts/argocd-apps"
  namespace        = kubernetes_namespace.this.metadata[0].name
  create_namespace = false

  values = [
    templatefile("${path.module}/charts/argocd-apps/values.yaml", {
      repository_name      = var.gitops_repository_name
      repository_url       = var.gitops_repository_url
      repository_username  = var.gitops_repository_username
      repository_password  = var.gitops_repository_password
      application_name     = var.django_release_name
      destination_namespace = var.destination_namespace
      source_repo_url      = var.gitops_repository_url
      source_target_revision = var.gitops_repository_branch
      source_path          = var.gitops_chart_path
      cluster_url          = "https://kubernetes.default.svc"
    })
  ]

  depends_on = [
    helm_release.argo_cd,
    kubernetes_namespace.django
  ]
}

data "kubernetes_secret_v1" "argocd_admin" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  depends_on = [helm_release.argo_cd]
}
