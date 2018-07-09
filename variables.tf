variable "k8s_cluster_name" {
  type = "string"
  description = "Cluster name"
}

variable "k8s_nodes_count" {
  type = "string"
  description = "Count of nodes"
}

variable "k8s_admin_username" {
  type        = "string"
  description = "Admin login."
}

variable "k8s_admin_password" {
  type ="string"
  description = "Admin password."
}

output "k8s_cluster_endpoint" {
  value = "${google_container_cluster.gcp_vpn.endpoint}"
}

output "k8s_ssh_command" {
  value = "ssh ${var.k8s_admin_username}@${google_container_cluster.gcp_vpn.endpoint}"
}

output "k8s_cluster_name" {
  value = "${google_container_cluster.gcp_vpn.name}"
}
