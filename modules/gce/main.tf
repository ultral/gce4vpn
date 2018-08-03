#resource "google_project_services" "openvpn_project" {
#  project = "${var.project}"
#
#  services = [
#    "bigquery-json.googleapis.com",
#    "container.googleapis.com",
#    "containerregistry.googleapis.com",
#    "deploymentmanager.googleapis.com",
#    "oslogin.googleapis.com",
#    "pubsub.googleapis.com ",
#    "replicapool.googleapis.com",
#    "replicapoolupdater.googleapis.com",
#    "resourceviews.googleapis.com",
#    "serviceusage.googleapis.com",
#    "storage-api.googleapis.com",
#    "storage-component.googleapis.com",
#    "iam.googleapis.com",
#    "compute.googleapis.com",
#    "compute-component.googleapis.com",
#    "servicemanagement.googleapis.com",
#    "cloudresourcemanager.googleapis.com",
#    "dns.googleapis.com"
#  ]
#}

resource "google_compute_network" "openvpn_network" {
  name                    = "${var.prefix}-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "openvpn_subnet" {
  name          = "${var.prefix}-subnet"
  ip_cidr_range = "${var.ip_range}"
  network       = "${google_compute_network.openvpn_network.self_link}"
  region        = "${var.region}"
}
