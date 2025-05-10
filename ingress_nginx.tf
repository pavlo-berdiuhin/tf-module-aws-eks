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