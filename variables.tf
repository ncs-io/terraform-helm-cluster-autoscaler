variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the AWS role for CA"
}

variable "ca_irsa_role_name" {
  type        = string
  description = "IRSA AWS IAM Role name for CA permissions"
}

variable "serviceaccount" {
  type        = string
  description = "CA ServiceAccount name"
  default     = "cluster-autoscaler"
}

variable "on" {
  type        = bool
  default     = true
  description = "Set to false to uninstall"
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "CA Namespace. Set to the same as IRSA role!"
}

variable "replica_count" {
  type    = number
  default = 2
}

variable "chart_version" {
  default = "9.19.1"
  type    = string
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name, obviously"
}