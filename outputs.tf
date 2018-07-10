output "k8s_cluster_endpoint" {
  value = "${google_container_cluster.gcp_vpn.endpoint}"
}

output "k8s_ssh_command" {
  value = "ssh ${var.k8s_admin_username}@${google_container_cluster.gcp_vpn.endpoint}"
}

output "k8s_cluster_name" {
  value = "${google_container_cluster.gcp_vpn.name}"
}


output "name" {
  value = "${kubernetes_replication_controller.echo.metadata.0.name}"
}

output "lb_ingress" {
  value = "${kubernetes_service.echo.load_balancer_ingress.0.ip}"
}
