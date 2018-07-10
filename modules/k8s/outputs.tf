output "k8s_cluster_endpoint" {
  value = "${google_container_cluster.gcp_vpn.endpoint}"
}

output "k8s_ssh_command" {
  value = "ssh ${var.k8s_admin_username}@${google_container_cluster.gcp_vpn.endpoint}"
}

output "k8s_cluster_name" {
  value = "${google_container_cluster.gcp_vpn.name}"
}
