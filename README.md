
# AWS EKS Cluster Autoscaler module for Terraform

*by macros*

**Install Cluster-Autoscaler**.

```
# Usage example:
module "cluster_autoscaler" {
  source            = "git@github.com:ncs-io/terraform-helm-cluster-autoscaler.git?ref=v1.1"
  cluster_name      = "MY_CLUSTER_NAME"
  namespace         = "kube-system"
  serviceaccount    = var.serviceaccount_name
  ca_irsa_role_name = var.aws_role_name
}
```

For full example, see [./examples](./examples).

## Versions

* v1.1 = chart v9.19.1 = ca 1.23.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ca_irsa_role_name"></a> [ca\_irsa\_role\_name](#input\_ca\_irsa\_role\_name) | IRSA AWS IAM Role name for CA permissions | `string` | n/a | yes |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | n/a | `string` | `"9.19.1"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name, obviously | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | CA Namespace. Set to the same as IRSA role! | `string` | `"kube-system"` | no |
| <a name="input_on"></a> [on](#input\_on) | Set to false to uninstall | `bool` | `true` | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | n/a | `number` | `2` | no |
| <a name="input_serviceaccount"></a> [serviceaccount](#input\_serviceaccount) | CA ServiceAccount name | `string` | `"cluster-autoscaler"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the AWS role for CA | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deployment_annotations"></a> [deployment\_annotations](#output\_deployment\_annotations) | n/a |
| <a name="output_service_account_annotations"></a> [service\_account\_annotations](#output\_service\_account\_annotations) | n/a |

Disclaimer: this code is auto-generated with [tf-docs](https://terraform-docs.io) by macros
