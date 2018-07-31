resource "kubernetes_persistent_volume" "openvpn_data" {
    metadata {
        name = "openvpn-data"
    }
    spec {
        capacity {
            storage = "2Gi"
        }
        access_modes = ["ReadWriteMany"]
        persistent_volume_source {
            gce_persistent_disk {
                pd_name = "${google_compute_disk.openvpn_data.name}"
                fs_type = "ext4"
            }
        }
    }
}

resource "google_compute_disk" "openvpn_data" {
  name  = "openvpn-data-disk"
  type  = "pd-ssd"
  zone  = "${var.openvpn_persistent_store_zone}"
  labels {
    app = "openvpn"
  }
}
