resource "google_container_cluster" "gcp_vpn" {
  name               = var.k8s_cluster_name
  description        = "k8s cluster"
  location           = var.gce_region
  enable_legacy_abac = "true"
  initial_node_count = var.k8s_nodes_count

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  monitoring_service = "monitoring.googleapis.com"

  node_config {
    machine_type = var.k8s_node_machine_type
    disk_size_gb = var.k8s_node_disk_size
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      label = "gce4vpn"
    }

    tags = ["gce4vpn"]
  }
  depends_on = [google_project_service.monitoring]
}
