output "ipaddr" {
  value = "${kubernetes_service.openvpn.load_balancer_ingress.0.ip}"
}

output "port" {
  value = "${var.openvpn_publish_port}"
}
