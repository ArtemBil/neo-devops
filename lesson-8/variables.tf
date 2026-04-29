variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-west-2"
}

variable "backend_bucket_name" {
  description = "Name of the S3 bucket used for Terraform state"
  type        = string
  default     = "artembilko-terraform-state"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table used for Terraform state locking"
  type        = string
  default     = "terraform-locks"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for public and private subnets"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "lesson-8-vpc"
}

variable "ecr_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "lesson-8-django-ecr"
}

variable "scan_on_push" {
  description = "Enable image scanning on push for the ECR repository"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "lesson-8-eks"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "node_group_name" {
  description = "Name of the managed node group"
  type        = string
  default     = "lesson-8-node-group"
}

variable "node_instance_types" {
  description = "EC2 instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "jenkins_namespace" {
  description = "Namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "jenkins_chart_version" {
  description = "Helm chart version for Jenkins"
  type        = string
  default     = "5.1.3"
}

variable "jenkins_admin_user" {
  description = "Jenkins admin username"
  type        = string
  default     = "admin"
}

variable "jenkins_admin_password" {
  description = "Jenkins admin password"
  type        = string
  default     = "change-me-jenkins"
  sensitive   = true
}

variable "github_credentials_id" {
  description = "Jenkins credentials ID used by the pipeline to push to Git"
  type        = string
  default     = "github-https-creds"
}

variable "argocd_namespace" {
  description = "Namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "Helm chart version for Argo CD"
  type        = string
  default     = "7.6.12"
}

variable "gitops_repository_url" {
  description = "Repository URL watched by Argo CD and updated by Jenkins"
  type        = string
  default     = "https://github.com/your-org/your-gitops-repo.git"
}

variable "gitops_repository_branch" {
  description = "Branch used by Jenkins and Argo CD"
  type        = string
  default     = "main"
}

variable "gitops_repository_name" {
  description = "Logical repository name inside Argo CD repository values"
  type        = string
  default     = "gitops-repo"
}

variable "gitops_chart_path" {
  description = "Path inside the GitOps repo where the Helm chart is stored"
  type        = string
  default     = "charts/django-app"
}

variable "gitops_repository_username" {
  description = "Optional username for the GitOps repository"
  type        = string
  default     = ""
  sensitive   = true
}

variable "gitops_repository_password" {
  description = "Optional password or token for the GitOps repository"
  type        = string
  default     = ""
  sensitive   = true
}

variable "django_release_name" {
  description = "Helm release name for the Django application"
  type        = string
  default     = "django-app"
}

variable "django_namespace" {
  description = "Kubernetes namespace where the Django application runs"
  type        = string
  default     = "django"
}

variable "common_tags" {
  description = "Common tags applied to all supported resources"
  type        = map(string)
  default = {
    Project     = "Neoversity"
    Environment = "lesson-8"
    ManagedBy   = "Terraform"
  }
}
