terraform {
  backend "gcs" {
    #bucket  = "gce4vpn-terraform-remote-states"
    prefix  = "terraform.tfstate"
  }
}

provider "google" {
  credentials = "${file("./.key.json")}"
  project     = "${file("./.project.name")}"
  region      = "${var.google_primary_zone}"
}
