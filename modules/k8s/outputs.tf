output "k8s_cluster_endpoint" {
  value = "${google_container_cluster.gcp_vpn.endpoint}"
}

output "k8s_ssh_command" {
  value = "ssh ${var.k8s_admin_username}@${google_container_cluster.gcp_vpn.endpoint}"
}

output "k8s_cluster_name" {
  value = "${google_container_cluster.gcp_vpn.name}"
}

output "k8s_admin_url" {
  value = "https://${google_container_cluster.gcp_vpn.endpoint}"
}

output "client_certificate" {
  value = "${google_container_cluster.gcp_vpn.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.gcp_vpn.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.gcp_vpn.master_auth.0.cluster_ca_certificate}"
}
