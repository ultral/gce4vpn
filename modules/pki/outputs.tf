output "openvpn_private_key" {
  value = base64encode(file("${var.openvpn_file_private_key}"))
}

output "openvpn_ca_crt" {
  value = base64encode(file("${var.openvpn_file_ca_crt}"))
}

output "openvpn_certificate_crt" {
  value = base64encode(file("${var.openvpn_file_certificate_crt}"))
}

output "openvpn_dh_pem" {
  value = base64encode(file("${var.openvpn_file_dh_pem}"))
}

output "openvpn_ta_key" {
  value = base64encode(file("${var.openvpn_file_ta_key}"))
}
