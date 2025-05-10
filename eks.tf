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
  create_cloudwatch_log_group     = var.create_cloudwatch_log_group

  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
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
    external-dns = {
      most_recent = true
    }
  }

  cluster_identity_providers = var.cluster_identity_providers

  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules

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