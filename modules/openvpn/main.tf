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
        env {
          name = "OVPN_K8S_DOMAIN"
          value_from {
            config_map_key_ref {
              name = "openvpn-settings"
              key = "domain"
            }
          }
        }
        env {
          name = "OVPN_STATUS"
          value_from {
            config_map_key_ref {
              name = "openvpn-settings"
              key = "statusfile"
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
        name = "openvpn-pki"
        secret {
            secret_name = "openvpn-pki"
            default_mode = 0400
        }
      }
      volume {
        name = "openvpn-status"
        empty_dir {}
      }
      volume {
        name = "openvpn-portmapping"
        config_map {
          name = "openvpn-portmapping"
        }
      }
      volume {
        name = "openvpn-crl"
        config_map {
          name = "openvpn-crl"
          default_mode = 0555
        }
      }
      volume {
        name = "openvpn-ccd"
        config_map {
          name = "openvpn-ccd"
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

