resource "helm_release" "ingress_nginx" {
  namespace        = "kube-system"
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.12.2"
  create_namespace = true
  atomic           = true
  max_history      = 5

  values = [
    templatefile("${path.module}/templates/ingress-nginx.yaml", {
      external_lb_enabled         = var.ingress_nginx_external_lb_enabled
      internal_lb_enabled         = var.ingress_nginx_internal_lb_enabled
      acm_cert_arn                = var.ingress_nginx_lb_cert_arn
      ingress_tcp_udp_config_maps = yamlencode(var.ingress_tcp_udp_config_maps)
    })
  ]
}


data "kubernetes_service" "ingress_controller_internal" {
  count = var.ingress_nginx_internal_lb_enabled ? 1 : 0

  metadata {
    name      = "ingress-nginx-controller-internal"
    namespace = "kube-system"
  }
  depends_on = [helm_release.ingress_nginx]
}

data "kubernetes_service" "ingress_controller_external" {
  count = var.ingress_nginx_external_lb_enabled ? 1 : 0

  metadata {
    name      = "ingress-nginx-controller-external"
    namespace = "kube-system"
  }
  depends_on = [helm_release.ingress_nginx]
}


data "aws_route53_zone" "public" {
  count = var.ingress_nginx_external_lb_enabled ? 1 : 0

  zone_id = var.public_route53_zone_id
}

data "aws_route53_zone" "private" {
  count = var.ingress_nginx_internal_lb_enabled ? 1 : 0

  zone_id = var.private_route53_zone_id
}


resource "aws_route53_record" "public_ingress_nginx" {
  count = var.ingress_nginx_external_lb_enabled ? 1 : 0

  zone_id = data.aws_route53_zone.public[0].id
  name    = "*.${data.aws_route53_zone.public[0].name}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_controller_external[0].status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "private_ingress_nginx" {
  count = var.ingress_nginx_internal_lb_enabled ? 1 : 0

  zone_id = data.aws_route53_zone.private[0].id
  name    = "*.${data.aws_route53_zone.private[0].name}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_controller_internal[0].status.0.load_balancer.0.ingress.0.hostname]
}