resource "google_container_cluster" "gcp_vpn" {
  name               = "${var.k8s_cluster_name}"
  zone               = "europe-north1-a"
  initial_node_count = "${var.k8s_nodes_count}"

  additional_zones = [
    "europe-north1-b",
    "europe-north1-c",
  ]

  master_auth {
    username = "${var.k8s_admin_username}"
    password = "${var.k8s_admin_password}}"
  }

  node_config {
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
