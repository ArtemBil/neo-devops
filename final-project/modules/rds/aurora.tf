resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier              = var.identifier
  engine                          = var.engine
  engine_version                  = var.engine_version
  database_name                   = var.db_name
  master_username                 = var.username
  master_password                 = var.password
  port                            = local.database_port
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.this.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this[0].name
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  storage_encrypted               = true
  deletion_protection             = var.deletion_protection
  skip_final_snapshot             = var.skip_final_snapshot
  apply_immediately               = var.apply_immediately

  tags = merge(local.merged_tags, {
    Name = var.identifier
  })
}

resource "aws_rds_cluster_instance" "writer" {
  count = var.use_aurora ? 1 : 0

  identifier           = "${var.identifier}-writer"
  cluster_identifier   = aws_rds_cluster.this[0].id
  instance_class       = var.instance_class
  engine               = var.engine
  engine_version       = var.engine_version
  db_subnet_group_name = aws_db_subnet_group.this.name
  publicly_accessible  = var.publicly_accessible

  tags = merge(local.merged_tags, {
    Name = "${var.identifier}-writer"
  })
}
