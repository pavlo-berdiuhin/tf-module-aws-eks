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
  default     = "eks"
}

variable "cluster_version" {
  type        = string
  description = "EKS cluster version"
}

variable "cluster_endpoint_public_access" {
  description = "EKS cluster public endpoint"
  type        = bool
  default     = false
}

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created. Set `source_node_security_group = true` inside rules to set the `node_security_group` as source"
  type        = any
  default     = {}
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

variable "on_demand_node_group_conf" {
  description = "On-demand node group configuration"
  type = object({
    ami_type       = optional(string, "BOTTLEROCKET_ARM_64")
    instance_types = optional(list(string), ["m7g.medium"])
    min_size       = optional(number, 2)
    max_size       = optional(number, 2)
    desired_size   = optional(number, 2)
  })
  default = {}
}
