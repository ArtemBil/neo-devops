output "bucket_name" {
  description = "S3 bucket name for Terraform state"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "bucket_url" {
  description = "S3 bucket URL"
  value       = "s3://${aws_s3_bucket.terraform_state.bucket}"
}

output "dynamodb_table_name" {
  description = "DynamoDB table name used for Terraform locking"
  value       = aws_dynamodb_table.terraform_locks.name
}
