output "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.this.name
}

output "security_group_id" {
  description = "Security group ID attached to the database"
  value       = aws_security_group.this.id
}

output "parameter_group_name" {
  description = "Name of the parameter group used by the database"
  value       = var.use_aurora ? aws_rds_cluster_parameter_group.this[0].name : aws_db_parameter_group.this[0].name
}

output "endpoint" {
  description = "Writer endpoint of the created database"
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
}

output "reader_endpoint" {
  description = "Reader endpoint for Aurora clusters"
  value       = var.use_aurora ? aws_rds_cluster.this[0].reader_endpoint : null
}

output "port" {
  description = "Database port"
  value       = local.database_port
}

output "resource_id" {
  description = "Main resource identifier of the created database"
  value       = var.use_aurora ? aws_rds_cluster.this[0].cluster_identifier : aws_db_instance.this[0].identifier
}
