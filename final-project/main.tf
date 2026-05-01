terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = var.backend_bucket_name
  table_name  = var.dynamodb_table_name

  tags = var.common_tags
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  vpc_name           = var.vpc_name
  cluster_name       = var.cluster_name

  tags = var.common_tags
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = var.ecr_name
  scan_on_push = var.scan_on_push

  tags = var.common_tags
}

module "eks" {
  source = "./modules/eks"

  cluster_name         = var.cluster_name
  kubernetes_version   = var.kubernetes_version
  subnet_ids           = module.vpc.private_subnet_ids
  node_group_name      = var.node_group_name
  node_instance_types  = var.node_instance_types
  desired_size         = var.node_desired_size
  min_size             = var.node_min_size
  max_size             = var.node_max_size
  enable_ebs_csi_driver = true

  tags = var.common_tags
}

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

module "jenkins" {
  source = "./modules/jenkins"

  cluster_name                    = module.eks.cluster_name
  cluster_endpoint                = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate          = data.aws_eks_cluster.this.certificate_authority[0].data
  cluster_auth_token              = data.aws_eks_cluster_auth.this.token
  namespace                       = var.jenkins_namespace
  chart_version                   = var.jenkins_chart_version
  admin_user                      = var.jenkins_admin_user
  admin_password                  = var.jenkins_admin_password
  github_credentials_id           = var.github_credentials_id
  github_repository_url           = var.application_repository_url
  github_branch                   = var.application_repository_branch
  jenkinsfile_path                = var.application_jenkinsfile_path
  ecr_repository_url              = module.ecr.repository_url
  aws_region                      = var.aws_region

  depends_on = [module.eks]
}

module "argo_cd" {
  source = "./modules/argo_cd"

  cluster_name                    = module.eks.cluster_name
  cluster_endpoint                = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate          = data.aws_eks_cluster.this.certificate_authority[0].data
  cluster_auth_token              = data.aws_eks_cluster_auth.this.token
  namespace                       = var.argocd_namespace
  chart_version                   = var.argocd_chart_version
  gitops_repository_url           = var.gitops_repository_url
  gitops_repository_branch        = var.gitops_repository_branch
  gitops_repository_name          = var.gitops_repository_name
  gitops_chart_path               = var.gitops_chart_path
  gitops_repository_username      = var.gitops_repository_username
  gitops_repository_password      = var.gitops_repository_password
  django_release_name             = var.django_release_name
  destination_namespace           = var.django_namespace

  depends_on = [module.eks]
}

module "rds" {
  source = "./modules/rds"

  identifier                 = var.rds_identifier
  use_aurora                 = var.rds_use_aurora
  engine                     = var.rds_engine
  engine_version             = var.rds_engine_version
  instance_class             = var.rds_instance_class
  db_name                    = var.rds_db_name
  username                   = var.rds_username
  password                   = var.rds_password
  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = module.vpc.private_subnet_ids
  allowed_cidr_blocks        = var.rds_allowed_cidr_blocks
  allowed_security_group_ids = var.rds_allowed_security_group_ids
  multi_az                   = var.rds_multi_az
  allocated_storage          = var.rds_allocated_storage
  max_allocated_storage      = var.rds_max_allocated_storage
  publicly_accessible        = var.rds_publicly_accessible
  backup_retention_period    = var.rds_backup_retention_period
  deletion_protection        = var.rds_deletion_protection
  skip_final_snapshot        = var.rds_skip_final_snapshot
  apply_immediately          = var.rds_apply_immediately

  tags = var.common_tags
}

module "monitoring" {
  source = "./modules/monitoring"

  cluster_endpoint       = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = data.aws_eks_cluster.this.certificate_authority[0].data
  cluster_auth_token     = data.aws_eks_cluster_auth.this.token
  namespace              = var.monitoring_namespace
  chart_version          = var.monitoring_chart_version
  grafana_admin_password = var.grafana_admin_password

  depends_on = [module.eks]
}
