module "gcp4tfstate" {
  source = "../../modules/gcp4tfstate"
  tfstate_region = "${var.gce_region}"
  tfstate_bucket = "${var.tfstate_bucket}"
}

module "k8s" {
  source = "../../modules/k8s"
  k8s_admin_username  = "${var.k8s_admin_username}"
  k8s_admin_password  = "${var.k8s_admin_password}"
  k8s_cluster_primary_zone = "${var.gce_region}-a"
  k8s_cluster_slave_zone1  = "${var.gce_region}-b"
  k8s_cluster_slave_zone2  = "${var.gce_region}-c"
}

module "pki" {
  source = "../../modules/pki"

  openvpn_file_private_key      = "${var.openvpn_files}/pki/private/${var.openvpn_cn}.key"
  openvpn_file_ca_crt           = "${var.openvpn_files}/pki/ca.crt"
  openvpn_file_certificate_crt  = "${var.openvpn_files}/pki/issued/${var.openvpn_cn}.crt"
  openvpn_file_dh_pem           = "${var.openvpn_files}/pki/dh.pem"
  openvpn_file_ta_key           = "${var.openvpn_files}/pki/ta.key"
}

module "openvpn" {
  source = "../../modules/openvpn"
  k8s_admin_username = "${var.k8s_admin_username}"
  k8s_admin_password = "${var.k8s_admin_password}"
  k8s_admin_url      = "${module.k8s.k8s_admin_url}"
  k8s_client_cert             = "${base64decode(module.k8s.client_certificate)}"
  k8s_client_key              = "${base64decode(module.k8s.client_key)}"
  k8s_cluster_ca_certificate  = "${base64decode(module.k8s.cluster_ca_certificate)}"

  openvpn_private_key     = "${base64decode(module.pki.openvpn_private_key)}"
  openvpn_ca_crt          = "${base64decode(module.pki.openvpn_ca_crt)}"
  openvpn_certificate_crt = "${base64decode(module.pki.openvpn_certificate_crt)}"
  openvpn_dh_pem          = "${base64decode(module.pki.openvpn_dh_pem)}"
  openvpn_ta_key          = "${base64decode(module.pki.openvpn_ta_key)}"
  openvpn_publish_port    = 443
}
