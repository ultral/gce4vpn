provider "google" {
  credentials = "${file("./.key.json")}"
  project     = "${var.google_project_name}"
  region      = "${var.k8s_cluster_primary_zone}"
}
