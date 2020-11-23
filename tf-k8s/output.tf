output "nginxip" {
  value = kubernetes_service.nginx_service.spec[0].external_ips
}