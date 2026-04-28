variable "ecr_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "scan_on_push" {
  description = "Enable scan on push for ECR images"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to ECR resources"
  type        = map(string)
  default     = {}
}
