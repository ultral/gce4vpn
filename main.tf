resource "google_container_cluster" "gcp_vpn" {
  name               = "${var.k8s_cluster_name}"
  description        = "k8s cluster"
  zone               = "${var.k8s_cluster_primary_zone}"
  enable_kubernetes_alpha = "true"
  enable_legacy_abac = "true"
  initial_node_count = "${var.k8s_nodes_count}"

  additional_zones = [
    "${var.k8s_cluster_slave_zone1}",
    "${var.k8s_cluster_slave_zone2}",
  ]

  master_auth {
    username = "${var.k8s_admin_username}"
    password = "${var.k8s_admin_password}}"
  }

  node_config {
    machine_type = "${var.node_machine_type}"
    disk_size_gb = "${var.node_disk_size}"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      label = "gce4vpn"
    }

    tags = ["gce4vpn"]
  }
}

resource "kubernetes_replication_controller" "echo" {
  metadata {
    name = "echo-example"

    labels {
      app = "echo_app"
    }
  }

  spec {
    selector {
      app = "echo_app"
    }
    template {
      container {
        image = "hashicorp/http-echo:0.2.1"
        name  = "example2"
        args = ["-listen=:88", "-text='${var.text_inside_test_container}'"]

        port {
          container_port = 88
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
      }
    }
  }
}

resource "kubernetes_service" "echo" {
  metadata {
    name = "echo-example"
  }

  spec {
    selector {
      app = "${kubernetes_replication_controller.echo.metadata.0.labels.app}"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 88
    }

    type = "LoadBalancer"
  }
}

