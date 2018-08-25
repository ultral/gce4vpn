resource "google_storage_bucket" "tfstate" {
  name     = "${var.tfstate_bucket}"
  location = "${var.tfstate_region}"
}
