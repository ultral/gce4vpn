resource "kubernetes_config_map" "openvpn" {
  metadata {
    name = "openvpn-settings"
  }

  data {
    servicecidr = "${var.service_cidr}"
    podcidr = "${var.pod_cidr}"
    serverurl = "${var.server_url}"
  }
}



