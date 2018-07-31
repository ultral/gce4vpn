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
        image = "kylemanna/openvpn"
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

resource "kubernetes_service" "echo" {
  metadata {
    name = "openvpn-publish"
  }

  spec {
    selector {
      app = "${kubernetes_replication_controller.openvpn.metadata.0.labels.app}"
    }

    port {
      name        = "https"
      port        = 443
      target_port = 1194
    }

    type = "LoadBalancer"
  }
}

