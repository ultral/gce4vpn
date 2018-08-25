resource "google_storage_bucket" "tfstate" {
  name     = "${var.tfstate_bucket}"
  location = "${var.tfstate_region}"
  depends_on = [
    "google_project_service.storageapi",
    "google_project_service.storagecomponent"
    ]
}
