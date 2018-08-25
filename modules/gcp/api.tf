resource "google_project_service" "storageapi" {
  service = "storage-api.googleapis.com"
}

resource "google_project_service" "storagecomponent" {
  service = "storage-component.googleapis.com"
}

resource "google_project_service" "monitoring" {
  service = "monitoring.googleapis.com"
}
