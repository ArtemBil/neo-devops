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
  default     = "final-project-vpc"
}

variable "ecr_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "final-project-django-ecr"
}

variable "scan_on_push" {
  description = "Enable image scanning on push for the ECR repository"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "final-project-eks"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "node_group_name" {
  description = "Name of the managed node group"
  type        = string
  default     = "final-project-node-group"
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

variable "application_repository_url" {
  description = "Application source repository used by Jenkins"
  type        = string
  default     = "https://github.com/your-org/your-app-repo.git"
}

variable "application_repository_branch" {
  description = "Application source repository branch used by Jenkins"
  type        = string
  default     = "main"
}

variable "application_jenkinsfile_path" {
  description = "Path to the Jenkinsfile inside the application repository"
  type        = string
  default     = "Django/Jenkinsfile"
}

variable "argocd_namespace" {
  description = "Namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "monitoring_namespace" {
  description = "Namespace for Prometheus and Grafana"
  type        = string
  default     = "monitoring"
}

variable "monitoring_chart_version" {
  description = "Helm chart version for kube-prometheus-stack"
  type        = string
  default     = "58.5.3"
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  default     = "change-me-grafana"
  sensitive   = true
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
    Environment = "final-project"
    ManagedBy   = "Terraform"
  }
}

variable "rds_identifier" {
  description = "Base identifier used for RDS resources"
  type        = string
  default     = "final-project-db"
}

variable "rds_use_aurora" {
  description = "Create Aurora instead of a standalone RDS instance"
  type        = bool
  default     = false
}

variable "rds_engine" {
  description = "Database engine used by the RDS module"
  type        = string
  default     = "postgres"
}

variable "rds_engine_version" {
  description = "Database engine version used by the RDS module"
  type        = string
  default     = "15.4"
}

variable "rds_instance_class" {
  description = "Instance class for the RDS module"
  type        = string
  default     = "db.t3.medium"
}

variable "rds_db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "rds_username" {
  description = "Master username for the database"
  type        = string
  default     = "dbadmin"
}

variable "rds_password" {
  description = "Master password for the database"
  type        = string
  default     = "change-me-db-password"
  sensitive   = true
}

variable "rds_allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to the database"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "rds_allowed_security_group_ids" {
  description = "Security groups allowed to connect to the database"
  type        = list(string)
  default     = []
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ for standalone RDS"
  type        = bool
  default     = false
}

variable "rds_allocated_storage" {
  description = "Allocated storage for standalone RDS in GiB"
  type        = number
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "Maximum autoscaled storage for standalone RDS in GiB"
  type        = number
  default     = 100
}

variable "rds_publicly_accessible" {
  description = "Create a public endpoint for the database"
  type        = bool
  default     = false
}

variable "rds_backup_retention_period" {
  description = "Automated backup retention in days"
  type        = number
  default     = 7
}

variable "rds_deletion_protection" {
  description = "Enable deletion protection for the database"
  type        = bool
  default     = false
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot when the database is destroyed"
  type        = bool
  default     = true
}

variable "rds_apply_immediately" {
  description = "Apply RDS changes immediately"
  type        = bool
  default     = true
}
