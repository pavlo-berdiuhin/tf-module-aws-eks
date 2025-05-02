output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS cluster endpoint"
}

output "eks_cluster_certificate_authority_data" {
  value       = module.eks.cluster_certificate_authority_data
  description = "base64 EKS certificate authority data"
}

output "eks_cluster_id" {
  value       = module.eks.cluster_id
  description = "EKS cluster ID"
}

output "eks_security_group_id" {
  value       = module.eks.node_security_group_id
  description = "EKS Worker nodes security group ID"
}

output "eks_oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "EKS OIDC provider ARN"
}
