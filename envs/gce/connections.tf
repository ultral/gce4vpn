terraform {
  backend "gcs" {
    prefix  = "terraform.tfstate"
  }
}

provider "google" {
  credentials = "${file("${path.module}/.key.json")}"
  project     = "${var.project}"
  region      = "${var.gce_region}"
}
