locals {
  cluster_name        = "MY_CLUSTER_NAME"
  region              = "eu-central-1"
  namespace           = "kube-system"
  serviceaccount_name = "cluster-autoscaler"
}

module "eks_role_for_ca" {
  source         = "git@github.com:ncs-io/aws-eks-irsa-role.git?ref=v1.1"
  cluster_name   = local.cluster_name
  namespace      = local.namespace
  serviceaccount = local.serviceaccount_name # the cluster-autoscaler default SA name
}

module "cluster_autoscaler" {
  source            = "../"
  cluster_name      = local.cluster_name
  namespace         = local.namespace
  serviceaccount    = local.serviceaccount_name
  ca_irsa_role_name = module.eks_role_for_ca.name
  chart_version     = "9.19.1"
}