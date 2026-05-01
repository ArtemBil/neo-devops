# Lesson 8 - Jenkins + Terraform + Helm + Argo CD

## Project structure

```text
lesson-8/
├── backend.tf
├── main.tf
├── outputs.tf
├── variables.tf
├── Jenkinsfile
├── README.md
├── modules/
│   ├── argo_cd/
│   │   ├── argo_cd.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── values.yaml
│   │   ├── variables.tf
│   │   └── charts/
│   │       └── argocd-apps/
│   │           ├── Chart.yaml
│   │           ├── values.yaml
│   │           └── templates/
│   │               ├── application.yaml
│   │               └── repository.yaml
│   ├── ecr/
│   ├── eks/
│   │   ├── aws_ebs_csi_driver.tf
│   │   ├── eks.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── jenkins/
│   │   ├── jenkins.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── values.yaml
│   │   └── variables.tf
│   ├── s3-backend/
│   └── vpc/
└── charts/
    └── django-app/
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
            ├── configmap.yaml
            ├── deployment.yaml
            ├── hpa.yaml
            ├── ingress.yaml
            └── service.yaml
```

## What is implemented

### Terraform
- `s3-backend` creates the S3 bucket for Terraform state and DynamoDB table for state locking.
- `vpc` creates the AWS network required for EKS, Jenkins, and Argo CD.
- `ecr` creates an ECR repository for the Django image.
- `eks` creates the EKS cluster, managed node group, IAM roles, and the EBS CSI driver addon.
- `rds` creates either a standalone RDS instance or an Aurora cluster, together with subnet, security, and parameter groups.
- `jenkins` installs Jenkins via Helm and prepares it for Kubernetes agents.
- `argo_cd` installs Argo CD via Helm and creates an Argo CD Application that watches the Helm chart in Git.

### CI/CD flow
- `Jenkinsfile` builds the Docker image from `Dockerfile`.
- Jenkins pushes the image to ECR with Kaniko.
- Jenkins updates the image tag in the GitOps repository `values.yaml`.
- Argo CD detects the change in Git and automatically syncs the Helm release in Kubernetes.

### Helm chart
- `charts/django-app` contains `Deployment`, `Service`, `ConfigMap`, `HPA`, and optional `Ingress`.
- Environment variables are passed through `ConfigMap` via `envFrom`.

## Terraform commands

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

Run them from the `lesson-8` directory.

## Jenkins pipeline flow

1. Jenkins checks out the application source code.
2. Kaniko builds the Docker image inside a Kubernetes agent pod.
3. Kaniko pushes the image to Amazon ECR.
4. Jenkins clones the GitOps repository and updates `charts/django-app/values.yaml`.
5. Jenkins pushes the updated tag to the `main` branch.
6. Argo CD automatically syncs the application in EKS.

## Required manual setup

Before running the full flow, update these variables in Terraform:
- `gitops_repository_url`
- `gitops_repository_username`
- `gitops_repository_password`
- `jenkins_admin_password`
- `rds_password`

## RDS module

The reusable module lives in `modules/rds` and supports both deployment modes:

- `rds_use_aurora = false` creates one `aws_db_instance`
- `rds_use_aurora = true` creates `aws_rds_cluster` + one writer instance

The root module already wires it to the private subnets from the VPC module.

### Example

```hcl
module "rds" {
  source = "./modules/rds"

  identifier          = "lesson-8-db"
  use_aurora          = false
  engine              = "postgres"
  engine_version      = "15.4"
  instance_class      = "db.t3.medium"
  db_name             = "appdb"
  username            = "dbadmin"
  password            = var.rds_password
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  allowed_cidr_blocks = [var.vpc_cidr_block]
  multi_az            = true
}
```

To switch database type, change:

- `rds_use_aurora`
- `rds_engine`
- `rds_engine_version`
- `rds_instance_class`
- `rds_multi_az`

For full variable documentation, see `modules/rds/README.md`.

In Jenkins, make sure these credentials exist:
- `github-https-creds`
- `ecr-repository-url`
- `aws-account-id`

## Useful commands

```bash
aws eks update-kubeconfig --region us-west-2 --name lesson-8-eks
kubectl get nodes
kubectl get pods -A
helm list -A
kubectl get applications -n argocd
```

## Notes
- Replace `artembilko-terraform-state` with a globally unique S3 bucket name.
- Backend resources must exist before using the S3 backend in `backend.tf`.
- Replace example GitHub URLs, repository credentials, and image repository values with real ones.
- For production, move sensitive app settings from `ConfigMap` to `Secret`.
