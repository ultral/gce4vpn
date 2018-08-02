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
        env {
          name = "OVPN_SERVER_URL"
          value_from {
            config_map_key_ref {
              name = "openvpn-settings"
              key = "serverurl"
            }
          }
        }
        env {
          name = "OVPN_K8S_SERVICE_NETWORK"
          value_from {
            config_map_key_ref {
              name = "openvpn-settings"
              key = "servicecidr"
            }
          }
        }
        env {
          name = "OVPN_K8S_POD_NETWORK"
          value_from {
            config_map_key_ref {
              name = "openvpn-settings"
              key = "podcidr"
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
          name = "/etc/openvpn/pki"
          mount_path = "openvpn-pki"
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

