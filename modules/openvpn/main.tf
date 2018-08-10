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
        image = "ultral/openvpn"
        name  = "opevpnsrv"

        security_context {
          capabilities {
            add = ["NET_ADMIN"]
          }
        }

        port {
          container_port = 1194
        }

        env {
          name = "PODIPADDR"
          value_from {
            field_ref {
              field_path = "status.podIP"
            }
          }
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

        volume_mount {
          mount_path = "/etc/openvpn/pki"
          name = "openvpn-pki"
        }
      }
      volume {
        name = "openvpn-pki"
        secret {
            secret_name = "openvpn-pki"
            default_mode = 0400
        }
      }
    }
  }
}

resource "kubernetes_service" "openvpn" {
  metadata {
    name = "openvpn-publish"
  }

  spec {
    selector {
      app = "${kubernetes_replication_controller.openvpn.metadata.0.labels.app}"
    }

    port {
      name        = "https"
      port        = "${var.openvpn_publish_port}"
      target_port = 1194
    }

    type = "LoadBalancer"
  }
}

