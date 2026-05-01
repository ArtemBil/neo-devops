variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones used by the subnets"
  type        = list(string)
}

variable "vpc_name" {
  description = "Name tag for the VPC and related resources"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster for subnet tags"
  type        = string
}

variable "tags" {
  description = "Tags applied to VPC resources"
  type        = map(string)
  default     = {}
}
