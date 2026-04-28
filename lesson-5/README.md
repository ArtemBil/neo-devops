# Lesson 5 - Terraform AWS Infrastructure

## Project structure

```text
lesson-5/
├── backend.tf
├── main.tf
├── outputs.tf
├── variables.tf
├── README.md
└── modules/
    ├── ecr/
    │   ├── ecr.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── s3-backend/
    │   ├── dynamodb.tf
    │   ├── outputs.tf
    │   ├── s3.tf
    │   └── variables.tf
    └── vpc/
        ├── outputs.tf
        ├── routes.tf
        ├── variables.tf
        └── vpc.tf
```

## What is implemented

### s3-backend
- Creates an S3 bucket for Terraform state storage.
- Enables bucket versioning to preserve state history.
- Enables server-side encryption and blocks public access.
- Creates a DynamoDB table for Terraform state locking.

### vpc
- Creates a VPC with DNS support and DNS hostnames enabled.
- Creates 3 public and 3 private subnets across 3 availability zones.
- Attaches an Internet Gateway for public traffic.
- Creates one NAT Gateway for outbound traffic from private subnets.
- Configures public and private route tables with subnet associations.

### ecr
- Creates an ECR repository for Docker images.
- Enables automatic image scanning on push.
- Adds a repository policy for read-oriented access actions.

## Terraform commands

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

Run them from the `lesson-5` directory.

## Notes
- Update the backend bucket name if you need a globally unique S3 bucket name.
- Apply the backend resources first or create them separately before relying on the S3 backend in `backend.tf`.
- Review the ECR repository policy before production use and scope it to your AWS account or IAM principals.
