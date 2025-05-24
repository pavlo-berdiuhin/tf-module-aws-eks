module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20"

  cluster_name                             = local.name
  cluster_version                          = var.cluster_version
  enable_irsa                              = true
  vpc_id                                   = var.vpc_id
  subnet_ids                               = var.subnet_ids
  control_plane_subnet_ids                 = var.subnet_ids
  create_cloudwatch_log_group              = var.create_cloudwatch_log_group
  cluster_endpoint_public_access           = var.cluster_endpoint_public_access
  cluster_endpoint_private_access          = true
  enable_cluster_creator_admin_permissions = true

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

  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules

  node_security_group_additional_rules = {
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      type        = "ingress"
      description = "Allow HTTP between nodes"
      self        = true
    }
    https = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      type        = "ingress"
      description = "Allow HTTP between nodes"
      self        = true
    }
  }

  eks_managed_node_groups = {
    (local.name) = {
      ami_type               = var.on_demand_node_group_conf.ami_type
      instance_types         = var.on_demand_node_group_conf.instance_types
      min_size               = var.on_demand_node_group_conf.min_size
      max_size               = var.on_demand_node_group_conf.max_size
      desired_size           = var.on_demand_node_group_conf.desired_size
      vpc_security_group_ids = []
      labels = {
        "karpenter.sh/controller" = "true"
      }
    }
  }

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