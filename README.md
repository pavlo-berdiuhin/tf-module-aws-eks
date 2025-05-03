# aws-eks module
This module creates an EKS cluster with Karpenter node controller.

### Userfull links:
- [AWS EKS](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)
- [Karpenter](https://kubernetes.io/docs/home/)
- [terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks)
- [terraform-aws-eks-pod-identity](https://github.com/terraform-aws-modules/terraform-aws-eks-pod-identity)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.40 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.7 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.40 |
| <a name="provider_aws.us-east-1"></a> [aws.us-east-1](#provider\_aws.us-east-1) | >= 5.40 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.7 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.27 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 20 |
| <a name="module_eks_irsa"></a> [eks\_irsa](#module\_eks\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~> 5.3 |
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | terraform-aws-modules/eks/aws//modules/karpenter | ~> 20 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.private_ingress_nginx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.public_ingress_nginx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.karpenter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.gp3_ext4_sc](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.karpenter_node_class](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.karpenter_node_pool](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [aws_ecrpublic_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecrpublic_authorization_token) | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_route53_zone.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_route53_zone.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [kubernetes_service.ingress_controller_external](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |
| [kubernetes_service.ingress_controller_internal](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags for all resources | `map(string)` | `{}` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_cluster_identity_providers"></a> [cluster\_identity\_providers](#input\_cluster\_identity\_providers) | External Identity Providers, e.g Okta, AzureSSO, Google Auth | `map(any)` | `{}` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | EKS cluster version | `string` | n/a | yes |
| <a name="input_create_cloudwatch_log_group"></a> [create\_cloudwatch\_log\_group](#input\_create\_cloudwatch\_log\_group) | Create CloudWatch log group | `bool` | `false` | no |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | Deployment name | `string` | `"eks"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_ingress_nginx_external_lb_enabled"></a> [ingress\_nginx\_external\_lb\_enabled](#input\_ingress\_nginx\_external\_lb\_enabled) | Enable external load balancer for ingress nginx | `bool` | `false` | no |
| <a name="input_ingress_nginx_internal_lb_enabled"></a> [ingress\_nginx\_internal\_lb\_enabled](#input\_ingress\_nginx\_internal\_lb\_enabled) | Enable internal load balancer for ingress nginx | `bool` | `true` | no |
| <a name="input_ingress_nginx_lb_cert_arn"></a> [ingress\_nginx\_lb\_cert\_arn](#input\_ingress\_nginx\_lb\_cert\_arn) | Attach ACM certificate to Load Balancer | `string` | n/a | yes |
| <a name="input_ingress_tcp_udp_config_maps"></a> [ingress\_tcp\_udp\_config\_maps](#input\_ingress\_tcp\_udp\_config\_maps) | TCP config map for ingress controller | `map(map(string))` | <pre>{<br/>  "tcp": {},<br/>  "upd": {}<br/>}</pre> | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Owner | `string` | n/a | yes |
| <a name="input_private_route53_zone_id"></a> [private\_route53\_zone\_id](#input\_private\_route53\_zone\_id) | Private Route53 zone ID | `string` | `null` | no |
| <a name="input_public_route53_zone_id"></a> [public\_route53\_zone\_id](#input\_public\_route53\_zone\_id) | Public Route53 zone ID | `string` | `null` | no |
| <a name="input_stack"></a> [stack](#input\_stack) | Installation stack | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs | `list(string)` | n/a | yes |
| <a name="input_team"></a> [team](#input\_team) | Team name | `string` | `"devops"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [eks\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | base64 EKS certificate authority data |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | EKS cluster endpoint |
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | EKS cluster ID |
| <a name="output_eks_oidc_provider_arn"></a> [eks\_oidc\_provider\_arn](#output\_eks\_oidc\_provider\_arn) | EKS OIDC provider ARN |
| <a name="output_eks_security_group_id"></a> [eks\_security\_group\_id](#output\_eks\_security\_group\_id) | EKS Worker nodes security group ID |
<!-- END_TF_DOCS -->