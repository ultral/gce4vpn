output "openvpn_private_key" {
  value = "${var.openvpn_raw_private_key}"
}

output "openvpn_ca_crt" {
  value = "${var.openvpn_raw_ca_crt}"
}

output "openvpn_certificate_crt" {
  value = "${var.openvpn_raw_certificate_crt}"
}

output "openvpn_dh_pem" {
  value = "${var.openvpn_raw_dh_pem}"
}

output "openvpn_ta_key" {
  value = "${var.openvpn_raw_ta_key}"
}
