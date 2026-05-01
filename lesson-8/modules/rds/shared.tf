locals {
  is_aurora   = var.use_aurora
  is_postgres = contains(["postgres", "aurora-postgresql"], var.engine)
  is_mysql    = contains(["mysql", "aurora-mysql"], var.engine)

  default_ports = {
    postgres          = 5432
    aurora-postgresql = 5432
    mysql             = 3306
    aurora-mysql      = 3306
  }

  database_port = coalesce(var.port, lookup(local.default_ports, var.engine, 5432))
  postgres_major = can(regex("^\\d+", var.engine_version)) ? regex("^\\d+", var.engine_version) : "15"
  mysql_major_minor = can(regex("^\\d+\\.\\d+", var.engine_version)) ? regex("^\\d+\\.\\d+", var.engine_version) : "8.0"

  derived_parameter_group_family = local.is_postgres ? format(
    "%s%s",
    local.is_aurora ? "aurora-postgresql" : "postgres",
    local.postgres_major
    ) : format(
    "%s%s",
    local.is_aurora ? "aurora-mysql" : "mysql",
    local.mysql_major_minor
  )

  parameter_group_family = coalesce(var.parameter_group_family, local.derived_parameter_group_family)

  default_parameters = local.is_postgres ? [
    {
      name         = "max_connections"
      value        = tostring(var.max_connections)
      apply_method = "pending-reboot"
    },
    {
      name         = "log_statement"
      value        = var.log_statement
      apply_method = "immediate"
    },
    {
      name         = "work_mem"
      value        = var.work_mem
      apply_method = "pending-reboot"
    }
  ] : [
    {
      name         = "max_connections"
      value        = tostring(var.max_connections)
      apply_method = "pending-reboot"
    }
  ]

  merged_tags = merge(var.tags, {
    Name = var.identifier
  })
}

resource "aws_db_subnet_group" "this" {
  name        = "${var.identifier}-subnet-group"
  description = "Subnet group for ${var.identifier}"
  subnet_ids  = var.subnet_ids

  tags = merge(local.merged_tags, {
    Name = "${var.identifier}-subnet-group"
  })
}

resource "aws_security_group" "this" {
  name        = "${var.identifier}-sg"
  description = "Security group for ${var.identifier}"
  vpc_id      = var.vpc_id

  tags = merge(local.merged_tags, {
    Name = "${var.identifier}-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "cidr" {
  for_each = toset(var.allowed_cidr_blocks)

  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value
  from_port         = local.database_port
  to_port           = local.database_port
  ip_protocol       = "tcp"
  description       = "Database access from ${each.value}"
}

resource "aws_vpc_security_group_ingress_rule" "security_group" {
  for_each = toset(var.allowed_security_group_ids)

  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = each.value
  from_port                    = local.database_port
  to_port                      = local.database_port
  ip_protocol                  = "tcp"
  description                  = "Database access from security group ${each.value}"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

resource "aws_db_parameter_group" "this" {
  count = local.is_aurora ? 0 : 1

  name        = "${var.identifier}-parameters"
  family      = local.parameter_group_family
  description = "Parameter group for ${var.identifier}"

  dynamic "parameter" {
    for_each = concat(local.default_parameters, var.additional_parameters)

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = merge(local.merged_tags, {
    Name = "${var.identifier}-parameters"
  })
}

resource "aws_rds_cluster_parameter_group" "this" {
  count = local.is_aurora ? 1 : 0

  name        = "${var.identifier}-cluster-parameters"
  family      = local.parameter_group_family
  description = "Cluster parameter group for ${var.identifier}"

  dynamic "parameter" {
    for_each = concat(local.default_parameters, var.additional_parameters)

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = merge(local.merged_tags, {
    Name = "${var.identifier}-cluster-parameters"
  })
}
