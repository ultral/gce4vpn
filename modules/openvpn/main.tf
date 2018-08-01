resource "kubernetes_replication_controller" "openvpn" {
  metadata {
    name = "openvpn-server"

    labels {
      app = "openvpn_app"
    }
  }

  spec {
    selector {
      app = "openvpn_app"
    }
    template {
      container {
        image = "ptlange/openvpn"
        name  = "opevpnsrv"

        port {
          container_port = 1194
        }

        resources{
          limits{
            cpu = "500m"
            memory = "512Mi"
          }
          requests{
            cpu = "250m"
            memory = "50Mi"
          }
        }

        capabilities{
          add = ["NET_ADMIN"]
        }
        volume_mount {
          name = "/etc/openvpn/pki"
          mount_path = "openvpn-pki"
        }
        volume_mount {
          name = "/etc/openvpn/crl"
          mount_path = "openvpn-crl"
        }
        volume_mount {
          name = "/etc/openvpn/ccd"
          mount_path = "openvpn-ccd"
        }
        volume_mount {
          name = "/etc/openvpn/portmapping"
          mount_path = "openvpn-portmapping"
        }
        volume_mount {
          name = "/etc/openvpn/status"
          mount_path = "openvpn-status"
        }
      }
      volume {
        name = "openvpn-persistent-storage"
        persistent_volume {
          claim_name = "${kubernetes_persistent_volume.openvpn_data.metadata.0.name}"
        }
      }
    }
  }
}

resource "kubernetes_service" "openvpn-service" {
  metadata {
    name = "openvpn-publish"
  }

  spec {
    selector {
      app = "${kubernetes_replication_controller.openvpn.metadata.0.labels.app}"
    }

    port {
      name        = "https"
      port        = 1194
      target_port = 443
    }

    type = "NodePort"
  }
}

