module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "~> 20"
  cluster_name                    = local.name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  vpc_id                          = var.vpc_id
  subnet_ids                      = var.subnet_ids
  control_plane_subnet_ids        = var.subnet_ids
  enable_irsa                     = true
  create_cloudwatch_log_group     = var.create_cloudwatch_log_group

  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.eks_irsa.iam_role_arn
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }

  cluster_identity_providers = var.cluster_identity_providers

  eks_managed_node_groups = {
    (local.name) = {
      ami_type               = "BOTTLEROCKET_ARM_64"
      instance_types         = ["m7g.medium"]
      create_security_group  = false
      min_size               = 1
      max_size               = 2
      desired_size           = 1
      vpc_security_group_ids = []
      labels = {
        "karpenter.sh/controller" = "true"
      }
    }
  }

  authentication_mode                      = "API"
  enable_cluster_creator_admin_permissions = true

  node_security_group_tags = {
    "karpenter.sh/discovery" = local.name
  }
}


module "eks_irsa" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version   = "~> 5.3"
  role_name = local.name

  attach_ebs_csi_policy = true

  oidc_providers = {
    (local.name) = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "kube-system:ebs-csi-controller-sa"
      ]
    }
  }
}


resource "kubectl_manifest" "gp3_ext4_sc" {
  yaml_body = <<-YAML
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gp3-ext4
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: ebs.csi.aws.com
allowVolumeExpansion: true
volumeBindingMode: WaitForFirstConsumer
parameters:
  type: gp3
  csi.storage.k8s.io/fstype: ext4
YAML
}