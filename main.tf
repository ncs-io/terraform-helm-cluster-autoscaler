/**
*
* # AWS EKS Cluster Autoscaler module for Terraform
*
* *by macros*
*
* **Install Cluster-Autoscaler**. 
* 
* ```
* # Usage example:
* module "cluster_autoscaler" {
*   source            = "git@github.com:ncs-io/terraform-helm-cluster-autoscaler.git?ref=v1.0"
*   cluster_name      = "MY_CLUSTER_NAME"
*   namespace         = "kube-system"
*   serviceaccount    = var.serviceaccount_name
*   ca_irsa_role_name = var.aws_role_name
* }
* ```
*
* For full example, see [./examples](./examples).
*
* ## Versions
* 
* * v1.0 = chart v9.19.1 = ca 1.23.0
*/

locals {
  role_name = var.ca_irsa_role_name
  tags = merge(var.tags,
    {
      "module" = "terraform-helm-cluster-autoscaler"
  })
}

data "aws_region" "this" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "autoscaler_service_policy" {
  #checkov:skip=CKV_AWS_107: Needed
  #checkov:skip=CKV_AWS_111: Needed
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "sts:AssumeRoleWithWebIdentity",
      "eks:DescribeNodegroup",
    ]

    resources = [
      "*"
    ]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "autoscaler" {
  description = "EKS Cluster Autoscaler Policy"
  name        = "${local.role_name}-policy"
  policy      = data.aws_iam_policy_document.autoscaler_service_policy.json
}

resource "aws_iam_role_policy_attachment" "autoscaler_service_role_policy" {
  role       = local.role_name
  policy_arn = aws_iam_policy.autoscaler.arn
}

resource "helm_release" "cluster_autoscaler" {
  count      = var.on == true ? 1 : 0
  name       = "cluster-autoscaler"
  namespace  = var.namespace
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  atomic     = true
  version    = var.chart_version

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "awsRegion"
    value = data.aws_region.this.name
  }

  set {
    name  = "replicaCount"
    value = var.replica_count
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = var.serviceaccount
  }

  dynamic "set" {
    for_each = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.role_name}"
    }
    content {
      name  = "rbac.serviceAccount.annotations.${replace(set.key, ".", "\\.")}" # https://medium.com/@nitinnbisht/annotation-in-helm-with-terraform-3fa04eb30b6e
      value = set.value
    }
  }
}

