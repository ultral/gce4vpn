terraform {
  backend "gcs" {
    bucket  = "terraform-remote-states"
    prefix  = "terraform.tfstate"
    project = "gce4vpn2"
  }
}

provider "google" {
  credentials = "${file("./.key.json")}"
  project     = "gce4vpn2"
  region      = "${var.google_primary_zone}"
}
