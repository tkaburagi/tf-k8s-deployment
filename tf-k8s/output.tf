output "nginxip" {
  value = kubernetes_service.nginx_service.spec.external_ips
}