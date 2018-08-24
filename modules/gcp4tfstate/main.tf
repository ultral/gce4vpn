resource "google_storage_bucket" "tfstate" {
  name     = "${var.tfstate_bucket}"
  location = "${var.tfstate_region}"
}

resource "google_project_service" "iam" {
  service = "iam.googleapis.com"
}
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "serviceusage" {
  service = "serviceusage.googleapis.com"
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}

resource "google_project_service" "storageapi" {
  service = "storage-api.googleapis.com"
}

resource "google_project_service" "storagecomponent" {
  service = "storage-component.googleapis.com"
}
