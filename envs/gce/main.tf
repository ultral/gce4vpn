module "k8s" {
  source = "../../modules/k8s"
  k8s_admin_username = "${var.k8s_admin_username}"
  k8s_admin_password = "${var.k8s_admin_password}"
}

module "echo" {
  source = "../../modules/echo"
  k8s_admin_username = "${var.k8s_admin_username}"
  k8s_admin_password = "${var.k8s_admin_password}"
  k8s_admin_url      = "${module.k8s.k8s_admin_url}"
  k8s_client_cert             = "${base64decode(module.k8s.client_certificate)}"
  k8s_client_key              = "${base64decode(module.k8s.client_key)}"
  k8s_cluster_ca_certificate  = "${base64decode(module.k8s.cluster_ca_certificate)}"
}

module "pki" {
  source = "../../modules/pki"

  #openvpn_raw_private_key = "${file("${path.root}/pki/private/${var.openvpn_common_name}.key")}"
  #openvpn_raw_ca_crt = "${file("${path.root}/ca.crt")}"
  #openvpn_raw_certificate_crt = "${file("${path.root}/issued/${var.openvpn_common_name}.crt")}"
  #openvpn_raw_dh_pem = "${file("${path.root}/pki/dh.pem")}"
  #openvpn_raw_ta_key = "${file("${path.root}/pki/ta.key")}"
  openvpn_raw_private_key = "${file("/root/2/pki/private/${var.openvpn_common_name}.key")}"
  openvpn_raw_ca_crt = "${file("/root/2/pki/ca.crt")}"
  openvpn_raw_certificate_crt = "${file("/root/2/pki/issued/${var.openvpn_common_name}.crt")}"
  openvpn_raw_dh_pem = "${file("/root/2/pki/dh.pem")}"
  openvpn_raw_ta_key = "${file("/root/2/pki/ta.key")}"
}

module "openvpn" {
  source = "../../modules/openvpn"
  k8s_admin_username = "${var.k8s_admin_username}"
  k8s_admin_password = "${var.k8s_admin_password}"
  k8s_admin_url      = "${module.k8s.k8s_admin_url}"
  k8s_client_cert             = "${base64decode(module.k8s.client_certificate)}"
  k8s_client_key              = "${base64decode(module.k8s.client_key)}"
  k8s_cluster_ca_certificate  = "${base64decode(module.k8s.cluster_ca_certificate)}"

  openvpn_private_key = "${base64encode(module.pki.openvpn_private_key)}"
  openvpn_ca_crt = "${base64encode(module.pki.openvpn_ca_crt)}"
  openvpn_certificate_crt = "${base64encode(module.pki.openvpn_certificate_crt)}"
  openvpn_dh_pem = "${base64encode(module.pki.openvpn_dh_pem)}"
  openvpn_ta_key = "${base64encode(module.pki.openvpn_ta_key)}"

  service_cidr = "10.55.240.0/20"
  pod_cidr = "10.52.0.0/14"
  server_url = "tcp://${var.openvpn_common_name}:443"
  domain = "svc.cluster.local"
}
