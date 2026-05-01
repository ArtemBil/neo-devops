variable "identifier" {
  description = "Base identifier used for RDS resources"
  type        = string
}

variable "use_aurora" {
  description = "Create an Aurora cluster instead of a standalone RDS instance"
  type        = bool
  default     = false
}

variable "engine" {
  description = "Database engine: postgres, mysql, aurora-postgresql, or aurora-mysql"
  type        = string
  default     = "postgres"

  validation {
    condition = contains([
      "postgres",
      "mysql",
      "aurora-postgresql",
      "aurora-mysql"
    ], var.engine)
    error_message = "Supported engines are postgres, mysql, aurora-postgresql, and aurora-mysql."
  }
}

variable "engine_version" {
  description = "Engine version for the selected database engine"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "Instance class for RDS or Aurora writer instance"
  type        = string
  default     = "db.t3.medium"
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "username" {
  description = "Master username for the database"
  type        = string
  default     = "dbadmin"
}

variable "password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID where database resources are created"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs used by the DB subnet group"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the database port"
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to reach the database port"
  type        = list(string)
  default     = []
}

variable "port" {
  description = "Custom database port. When null, the default engine port is used"
  type        = number
  default     = null
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for a standalone RDS instance"
  type        = bool
  default     = false
}

variable "allocated_storage" {
  description = "Allocated storage in GiB for a standalone RDS instance"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum autoscaled storage in GiB for a standalone RDS instance"
  type        = number
  default     = 100
}

variable "storage_type" {
  description = "Storage type for a standalone RDS instance"
  type        = string
  default     = "gp3"
}

variable "publicly_accessible" {
  description = "Whether the database instance should have a public endpoint"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Preferred backup window in UTC"
  type        = string
  default     = "03:00-04:00"
}

variable "preferred_maintenance_window" {
  description = "Preferred maintenance window in UTC"
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

variable "deletion_protection" {
  description = "Enable deletion protection for the database"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting the database"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply modifications immediately"
  type        = bool
  default     = true
}

variable "parameter_group_family" {
  description = "Optional parameter group family override"
  type        = string
  default     = null
}

variable "max_connections" {
  description = "Value for the max_connections parameter"
  type        = number
  default     = 200
}

variable "log_statement" {
  description = "Value for the PostgreSQL log_statement parameter"
  type        = string
  default     = "ddl"
}

variable "work_mem" {
  description = "Value for the PostgreSQL work_mem parameter"
  type        = string
  default     = "4096"
}

variable "additional_parameters" {
  description = "Extra DB parameters appended to the default parameter set"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "immediate")
  }))
  default = []
}

variable "tags" {
  description = "Tags applied to all supported resources"
  type        = map(string)
  default     = {}
}
