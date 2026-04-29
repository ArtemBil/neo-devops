output "terraform_state_bucket_name" {
  description = "Name of the S3 bucket storing Terraform state"
  value       = module.s3_backend.bucket_name
}

output "terraform_locks_table_name" {
  description = "Name of the DynamoDB table used for Terraform state locking"
  value       = module.s3_backend.dynamodb_table_name
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "jenkins_url" {
  description = "Internal Jenkins service URL"
  value       = module.jenkins.jenkins_url
}

output "jenkins_admin_user" {
  description = "Jenkins admin username"
  value       = module.jenkins.admin_user
}

output "argocd_server_url" {
  description = "Internal Argo CD server URL"
  value       = module.argo_cd.argocd_server_url
}

output "argocd_initial_admin_password" {
  description = "Initial Argo CD admin password"
  value       = module.argo_cd.argocd_initial_admin_password
  sensitive   = true
}
