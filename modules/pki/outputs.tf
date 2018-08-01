variable "openvpn_private_key" {
  outputs = "${var.openvpn_raw_private_key}"
}

variable "openvpn_ca_crt" {
  outputs = "${var.openvpn_raw_ca_crt}"
}

variable "openvpn_certificate_crt" {
  outputs = "${var.openvpn_raw_certificate_crt}"
}

variable "openvpn_dh_pem" {
  outputs = "${var.openvpn_raw_dh_pem}"
}

variable "openvpn_ta_key" {
  outputs = "${var.openvpn_raw_ta_key}"
}
