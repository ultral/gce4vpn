#GOOGLE_CREDENTIALS=$(cat .key.json) terraform init
#terraform {
#  backend "gcs" {
#    bucket  = "terraform-remote-states"
#    prefix  = "terraform.tfstate"
#    project = "gce4vpn2"
#  }
#}

provider "google" {
  credentials = "${file("./.key.json")}"
  project     = "${file("./.project.name")}"
  region      = "${var.google_primary_zone}"
}
