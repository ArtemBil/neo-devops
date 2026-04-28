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
  default     = "lesson-5-vpc"
}

variable "ecr_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "lesson-5-ecr"
}

variable "scan_on_push" {
  description = "Enable image scanning on push for the ECR repository"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags applied to all supported resources"
  type        = map(string)
  default = {
    Project     = "Neoversity"
    Environment = "lesson-5"
    ManagedBy   = "Terraform"
  }
}
