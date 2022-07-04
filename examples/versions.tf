provider "aws" {
  region = local.region
}

data "aws_eks_cluster" "this" {
  name = local.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
      command     = "aws"
    }
  }
}

terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      version = "~> 4.21"
      source  = "hashicorp/aws"
    }
    helm = {
      version = "~> 2.6"
      source  = "hashicorp/helm"
    }
  }
}