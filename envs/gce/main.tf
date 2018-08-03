module "gce" {
  source = "../../modules/gce"
  project  = "${var.project}"
  region   = "${var.gce_region}"
  ip_range = "${var.k8s_service_cidr}"
}

module "k8s" {
  source = "../../modules/k8s"
  k8s_admin_username  = "${var.k8s_admin_username}"
  k8s_admin_password  = "${var.k8s_admin_password}"
  k8s_network         = "${module.gce.network_name}"
  k8s_subnetwork      = "${module.gce.subnet_name}"
  k8s_cluster_primary_zone = "${module.gce.zone_primary}"
  k8s_cluster_slave_zone1  = "${module.gce.zone_slave1}"
  k8s_cluster_slave_zone2  = "${module.gce.zone_slave2}"
}

module "pki" {
  source = "../../modules/pki"

  openvpn_file_private_key      = "${var.openvpn_files}/pki/private/vpn.some.domain.key"
  openvpn_file_ca_crt           = "${var.openvpn_files}/pki/ca.crt"
  openvpn_file_certificate_crt  = "${var.openvpn_files}/pki/issued/vpn.some.domain.crt"
  openvpn_file_dh_pem           = "${var.openvpn_files}/pki/dh.pem"
  openvpn_file_ta_key           = "${var.openvpn_files}/pki/ta.key"
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

  openvpn_private_key     = "${base64decode(module.pki.openvpn_private_key)}"
  openvpn_ca_crt          = "${base64decode(module.pki.openvpn_ca_crt)}"
  openvpn_certificate_crt = "${base64decode(module.pki.openvpn_certificate_crt)}"
  openvpn_dh_pem          = "${base64decode(module.pki.openvpn_dh_pem)}"
  openvpn_ta_key          = "${base64decode(module.pki.openvpn_ta_key)}"
  openvpn_server_url      = "tcp://${var.openvpn_cn}:443"
}
