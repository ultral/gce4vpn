output "vpn_server_addr" {
  value = "${module.openvpn.ipaddr}"
}

output "vpn_server_port" {
  value = "${module.openvpn.port}"
}
