output "echo_service_ip" {
  value = "${module.echo.lb_ingress}"
}

output "vpn_server_ip" {
  value = "${module.openvpn.ipaddr}"
}
