variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs where the EKS cluster and nodes will run"
  type        = list(string)
}

variable "node_group_name" {
  description = "Name of the EKS managed node group"
  type        = string
}

variable "node_instance_types" {
  description = "Instance types used for worker nodes"
  type        = list(string)
}

variable "desired_size" {
  description = "Desired number of nodes"
  type        = number
}

variable "min_size" {
  description = "Minimum number of nodes"
  type        = number
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number
}

variable "enable_ebs_csi_driver" {
  description = "Enable EBS CSI driver addon"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to EKS resources"
  type        = map(string)
  default     = {}
}
