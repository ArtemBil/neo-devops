# Final Project - AWS DevOps Platform

## Project structure

```text
final-project/
├── backend.tf
├── main.tf
├── outputs.tf
├── variables.tf
├── README.md
├── Django/
│   ├── app/
│   ├── Dockerfile
│   ├── Jenkinsfile
│   ├── docker-compose.yaml
│   └── requirements.txt
├── modules/
│   ├── argo_cd/
│   ├── ecr/
│   ├── eks/
│   ├── jenkins/
│   ├── monitoring/
│   ├── rds/
│   ├── s3-backend/
│   └── vpc/
└── charts/
    └── django-app/
```

## What is implemented

### Infrastructure
- `s3-backend` creates the S3 bucket for Terraform state and the DynamoDB lock table.
- `vpc` creates the VPC, public/private subnets, internet gateway, NAT gateway, and routes.
- `ecr` creates the ECR repository for the Django image.
- `eks` creates the Kubernetes cluster and managed node group.
- `rds` creates either a standalone RDS instance or an Aurora cluster.
- `jenkins` installs Jenkins through Helm.
- `argo_cd` installs Argo CD and a bootstrap applications chart.
- `monitoring` installs Prometheus and Grafana through `kube-prometheus-stack`.

### Application delivery
- `Django/Jenkinsfile` builds and pushes the Docker image to ECR.
- Jenkins updates the tag in the GitOps repository.
- Argo CD watches the GitOps repository and syncs the Helm release into EKS.
- `charts/django-app` contains the deployment, service, configmap, HPA, and ingress templates.

### Django application
- `Django/app` contains a minimal Django service with `/` and `/healthz/`.
- `Django/docker-compose.yaml` allows a simple local run.
- `Django/Dockerfile` is ready for local builds and Jenkins/Kaniko builds.

## Terraform commands

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform destroy
```

Run them from the `final-project` directory.

## Required variables to review

Before applying the stack, update these variables:
- `backend_bucket_name`
- `application_repository_url`
- `gitops_repository_url`
- `gitops_repository_username`
- `gitops_repository_password`
- `jenkins_admin_password`
- `rds_password`
- `grafana_admin_password`

## Example deployment checks

```bash
aws eks update-kubeconfig --region us-west-2 --name final-project-eks
kubectl get nodes
kubectl get all -n jenkins
kubectl get all -n argocd
kubectl get all -n monitoring
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
kubectl port-forward svc/argocd-server 8081:443 -n argocd
kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring
```

## RDS module

The reusable module in `modules/rds` supports:
- `rds_use_aurora = false` for one `aws_db_instance`
- `rds_use_aurora = true` for `aws_rds_cluster` and one writer instance

It also creates:
- DB subnet group
- security group
- parameter group

See `modules/rds/README.md` for detailed inputs and usage.

## Notes
- Replace `artembilko-terraform-state` with a globally unique S3 bucket name.
- Backend resources must exist before switching to the S3 backend in `backend.tf`.
- Replace placeholder GitHub URLs and credentials with real values.
- For production, move sensitive app settings from `ConfigMap` to `Secret`.
- Destroy unused AWS resources to avoid unnecessary charges.
