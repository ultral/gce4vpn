resource "kubernetes_config_map" "example" {
  metadata {
    app = "openvpn"
    name = "openvpn-settings"
  }

  data {
    servicecidr = "${var.service_cidr}"
    podcidr = "${var.pod_cidr}"
    serverurl = "${var.server_url}"
    domain = "${var.domain}"
    api_host = "myhost:443"
    statusfile  = "/etc/openvpn/status/server.status"
  }
}



