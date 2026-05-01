resource "aws_db_instance" "this" {
  count = var.use_aurora ? 0 : 1

  identifier                   = var.identifier
  engine                       = var.engine
  engine_version               = var.engine_version
  instance_class               = var.instance_class
  db_name                      = var.db_name
  username                     = var.username
  password                     = var.password
  port                         = local.database_port
  allocated_storage            = var.allocated_storage
  max_allocated_storage        = var.max_allocated_storage
  storage_type                 = var.storage_type
  multi_az                     = var.multi_az
  publicly_accessible          = var.publicly_accessible
  db_subnet_group_name         = aws_db_subnet_group.this.name
  vpc_security_group_ids       = [aws_security_group.this.id]
  parameter_group_name         = aws_db_parameter_group.this[0].name
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  storage_encrypted            = true
  deletion_protection          = var.deletion_protection
  skip_final_snapshot          = var.skip_final_snapshot
  apply_immediately            = var.apply_immediately

  tags = merge(local.merged_tags, {
    Name = var.identifier
  })
}
