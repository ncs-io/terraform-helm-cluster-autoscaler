output "service_account_annotations" {
  value = {
    "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.role_name}"
  }
}

output "deployment_annotations" {
  value = {
    "cluster-autoscaler.kubernetes.io/safe-to-evict" = "false"
  }
}
