output "ipaddr" {
  value = "${kubernetes_service.openvpn.load_balancer_ingress.0.ip}"
}
