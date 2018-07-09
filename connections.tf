provider "google" {
  credentials = "${file("./.key.json")}"
  project     = "gce4vpn"
  region      = "europe-north1-a"
}
