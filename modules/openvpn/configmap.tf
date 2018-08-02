resource "kubernetes_config_map" "openvpn" {
  metadata {
    name = "openvpn-settings"
  }

  data {
    servicecidr = "${var.k8s_service_cidr}"
    podcidr = "${var.k8s_pod_cidr}"
    serverurl = "${var.openvpn_server_url}"
  }
}
