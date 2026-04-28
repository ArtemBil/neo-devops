variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)

  validation {
    condition     = length(var.public_subnets) == 3
    error_message = "Exactly 3 public subnets are required."
  }
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)

  validation {
    condition     = length(var.private_subnets) == 3
    error_message = "Exactly 3 private subnets are required."
  }
}

variable "availability_zones" {
  description = "Availability zones used by the subnets"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 3
    error_message = "Exactly 3 availability zones are required."
  }
}

variable "vpc_name" {
  description = "Name tag for the VPC and related resources"
  type        = string
}

variable "tags" {
  description = "Tags applied to VPC resources"
  type        = map(string)
  default     = {}
}
