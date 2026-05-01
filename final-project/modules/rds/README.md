# RDS module

This module creates a reusable database layer for AWS and supports two modes:

- `use_aurora = false` creates one standalone Amazon RDS instance.
- `use_aurora = true` creates an Amazon Aurora cluster with one writer instance.

In both modes the module also creates:

- `aws_db_subnet_group`
- `aws_security_group`
- the matching parameter group for the selected database type

## Example usage

```hcl
module "rds" {
  source = "./modules/rds"

  identifier          = "lesson-8-db"
  use_aurora          = false
  engine              = "postgres"
  engine_version      = "15.4"
  instance_class      = "db.t3.medium"
  db_name             = "appdb"
  username            = "dbadmin"
  password            = var.rds_password
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  allowed_cidr_blocks = [var.vpc_cidr_block]
  multi_az            = true

  tags = var.common_tags
}
```

## Variables

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `identifier` | Base identifier used for all DB resources | `string` | n/a |
| `use_aurora` | Switches between Aurora and standalone RDS | `bool` | `false` |
| `engine` | Engine type: `postgres`, `mysql`, `aurora-postgresql`, `aurora-mysql` | `string` | `"postgres"` |
| `engine_version` | Engine version | `string` | `"15.4"` |
| `instance_class` | Instance class for the DB instance or Aurora writer | `string` | `"db.t3.medium"` |
| `db_name` | Initial database name | `string` | `"appdb"` |
| `username` | Master username | `string` | `"dbadmin"` |
| `password` | Master password | `string` | n/a |
| `vpc_id` | VPC ID for the security group | `string` | n/a |
| `subnet_ids` | Private subnet IDs used by the DB subnet group | `list(string)` | n/a |
| `allowed_cidr_blocks` | CIDR blocks allowed to connect to the DB port | `list(string)` | `[]` |
| `allowed_security_group_ids` | Security groups allowed to connect to the DB port | `list(string)` | `[]` |
| `port` | Custom database port | `number` | `null` |
| `multi_az` | Enables Multi-AZ for standalone RDS | `bool` | `false` |
| `allocated_storage` | Allocated storage for standalone RDS in GiB | `number` | `20` |
| `max_allocated_storage` | Maximum autoscaled storage for standalone RDS in GiB | `number` | `100` |
| `storage_type` | Storage type for standalone RDS | `string` | `"gp3"` |
| `publicly_accessible` | Creates a public endpoint when enabled | `bool` | `false` |
| `backup_retention_period` | Automated backup retention days | `number` | `7` |
| `preferred_backup_window` | Backup window in UTC | `string` | `"03:00-04:00"` |
| `preferred_maintenance_window` | Maintenance window in UTC | `string` | `"Mon:04:00-Mon:05:00"` |
| `deletion_protection` | Protects the DB from deletion | `bool` | `false` |
| `skip_final_snapshot` | Skips final snapshot on delete | `bool` | `true` |
| `apply_immediately` | Applies changes immediately | `bool` | `true` |
| `parameter_group_family` | Optional override for parameter group family | `string` | `null` |
| `max_connections` | Base DB parameter for connection count | `number` | `200` |
| `log_statement` | PostgreSQL `log_statement` value | `string` | `"ddl"` |
| `work_mem` | PostgreSQL `work_mem` value | `string` | `"4096"` |
| `additional_parameters` | Additional DB parameters | `list(object)` | `[]` |
| `tags` | Common AWS tags | `map(string)` | `{}` |

## How to change database type

- To create a standalone PostgreSQL instance, set `use_aurora = false` and `engine = "postgres"`.
- To create a standalone MySQL instance, set `use_aurora = false` and `engine = "mysql"`.
- To create Aurora PostgreSQL, set `use_aurora = true` and `engine = "aurora-postgresql"`.
- To create Aurora MySQL, set `use_aurora = true` and `engine = "aurora-mysql"`.

Update `engine_version`, `instance_class`, and `multi_az` through variables without changing module code.

## Parameter groups

- PostgreSQL-compatible engines get `max_connections`, `log_statement`, and `work_mem`.
- MySQL-compatible engines get `max_connections` by default.
- Use `additional_parameters` to append engine-specific settings when needed.
