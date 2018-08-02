output "project" {
  value = "${var.project}"
}

output "region" {
  value = "${var.region}"
}

output "network_name" {
  value = "${google_compute_network.openvpn_network.name}"
}

output "subnet_name" {
  value = "${google_compute_subnetwork.openvpn_subnet.name}"
}
