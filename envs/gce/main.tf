module "k8s" {
  source = "../../modules/k8s"
  k8s_admin_username = "${var.k8s_admin_username}"
  k8s_admin_password = "${var.k8s_admin_password}"
}

module "pki" {
  source = "../../modules/pki"

  openvpn_file_private_key      = "${var.openvpn_file_private_key}"
  openvpn_file_ca_crt           = "${var.openvpn_file_ca_crt}"
  openvpn_file_certificate_crt  = "${var.openvpn_file_certificate_crt}"
  openvpn_file_dh_pem           = "${var.openvpn_file_dh_pem}"
  openvpn_file_ta_key           = "${var.openvpn_file_ta_key}"
}

module "openvpn" {
  source = "../../modules/openvpn"
  k8s_admin_username = "${var.k8s_admin_username}"
  k8s_admin_password = "${var.k8s_admin_password}"
  k8s_admin_url      = "${module.k8s.k8s_admin_url}"
  k8s_service_cidr   = "${var.k8s_service_cidr}"
  k8s_pod_cidr       = "${var.k8s_pod_cidr}"
  k8s_client_cert             = "${base64decode(module.k8s.client_certificate)}"
  k8s_client_key              = "${base64decode(module.k8s.client_key)}"
  k8s_cluster_ca_certificate  = "${base64decode(module.k8s.cluster_ca_certificate)}"

  openvpn_private_key     = "${module.pki.openvpn_private_key}"
  openvpn_ca_crt          = "${module.pki.openvpn_ca_crt}"
  openvpn_certificate_crt = "${module.pki.openvpn_certificate_crt}"
  openvpn_dh_pem          = "${module.pki.openvpn_dh_pem}"
  openvpn_ta_key          = "${module.pki.openvpn_ta_key}"
  openvpn_server_url      = "tcp://${var.openvpn_common_name}:443"
}
