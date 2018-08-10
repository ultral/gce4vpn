resource "google_container_cluster" "gcp_vpn" {
  name               = "${var.k8s_cluster_name}"
  description        = "k8s cluster"
  zone               = "${var.k8s_cluster_primary_zone}"
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

  monitoring_service = "monitoring.googleapis.com"

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
