variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
}

variable "table_name" {
  description = "Name of the DynamoDB table for Terraform locking"
  type        = string
}

variable "tags" {
  description = "Tags applied to backend resources"
  type        = map(string)
  default     = {}
}
