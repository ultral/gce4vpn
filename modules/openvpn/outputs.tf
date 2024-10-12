output "ipaddr" {
  value = kubernetes_service.openvpn.status[0].load_balancer[0].ingress[0].ip
}

output "port" {
  value = var.openvpn_publish_port
}
