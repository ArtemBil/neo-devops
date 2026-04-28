# Lesson 7 - Terraform EKS and Helm Django App

## Project structure

```text
lesson-7/
├── backend.tf
├── main.tf
├── outputs.tf
├── variables.tf
├── README.md
├── modules/
│   ├── ecr/
│   │   ├── ecr.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── eks/
│   │   ├── eks.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── s3-backend/
│   │   ├── dynamodb.tf
│   │   ├── outputs.tf
│   │   ├── s3.tf
│   │   └── variables.tf
│   └── vpc/
│       ├── outputs.tf
│       ├── routes.tf
│       ├── variables.tf
│       └── vpc.tf
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
- `vpc` creates one VPC, 3 public subnets, 3 private subnets, one Internet Gateway, one NAT Gateway, and route tables.
- `ecr` creates an ECR repository for the Django Docker image with scan on push enabled.
- `eks` creates an EKS cluster with a managed node group inside the private subnets of the same VPC.

### Helm chart
- `Deployment` deploys the Django application from ECR and uses `envFrom` with a ConfigMap.
- `Service` exposes the application with the `LoadBalancer` type.
- `HPA` scales pods from 2 to 6 when CPU utilization is above 70%.
- `ConfigMap` stores environment variables moved from theme 4.
- `Ingress` is included as a bonus and is controlled through `values.yaml`.

## Terraform commands

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

Run them from the `lesson-7` directory.

## Deploy the Docker image to ECR

After `terraform apply`, use the ECR URL from outputs:

```bash
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-west-2.amazonaws.com
docker build -t lesson-7-django-app .
docker tag lesson-7-django-app:latest <ECR_REPOSITORY_URL>:latest
docker push <ECR_REPOSITORY_URL>:latest
```

## Connect to the cluster

```bash
aws eks update-kubeconfig --region us-west-2 --name lesson-7-eks
kubectl get nodes
```

## Install metrics-server

HPA based on CPU requires metrics-server:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

## Deploy the Helm chart

Update `charts/django-app/values.yaml` with your real ECR repository URL and image tag, then run:

```bash
helm upgrade --install django-app ./charts/django-app
kubectl get svc,hpa,pods
```

## Bonus ingress

To enable ingress with TLS, set:

```yaml
ingress:
  enabled: true
  className: nginx
  host: yourdomain.com
  path: /
  pathType: Prefix
  tls: true
  clusterIssuer: letsencrypt-prod
```

## Notes
- Replace `artembilko-terraform-state` with a globally unique S3 bucket name.
- Backend resources must exist before using the S3 backend in `backend.tf`.
- Replace example image values in Helm with the real ECR repository URL from Terraform outputs.
- `SECRET` values should normally be stored in Kubernetes Secrets; this homework keeps them in ConfigMap to match the task requirements.
