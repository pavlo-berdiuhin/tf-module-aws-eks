variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "stack" {
  type        = string
  description = "Installation stack"
}

variable "owner" {
  type        = string
  description = "Owner"
}

variable "team" {
  type        = string
  description = "Team name"
  default     = "devops"
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags for all resources"
  default     = {}
}

variable "deployment_name" {
  type        = string
  description = "Deployment name"
}

variable "cluster_version" {
  type        = string
  description = "EKS cluster version"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs"
}

variable "cluster_identity_providers" {
  description = "External Identity Providers, e.g Okta, AzureSSO, Google Auth"
  type        = map(any)
  default     = {}
}

variable "create_cloudwatch_log_group" {
  description = "Create CloudWatch log group"
  type        = bool
  default     = false
}

variable "ingress_nginx_external_lb_enabled" {
  type        = bool
  description = "Enable external load balancer for ingress nginx"
  default     = false
}
variable "ingress_nginx_internal_lb_enabled" {
  type        = bool
  description = "Enable internal load balancer for ingress nginx"
  default     = true
}
variable "ingress_nginx_lb_cert_arn" {
  description = "Attach ACM certificate to Load Balancer"
  type        = string
}
variable "ingress_tcp_udp_config_maps" {
  description = "TCP config map for ingress controller"
  type        = map(map(string))
  default = {
    tcp = {}
    upd = {}
  }
}

variable "private_route53_zone_id" {
  type        = string
  description = "Private Route53 zone ID"
  default     = null
}

variable "public_route53_zone_id" {
  type        = string
  description = "Public Route53 zone ID"
  default     = null
}
