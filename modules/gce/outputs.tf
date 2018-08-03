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

output "zone_primary" {
  value = "${var.region}-a"
}

output "zone_slave1" {
  value = "${var.region}-b"
}

output "zone_slave2" {
  value = "${var.region}-c"
}
