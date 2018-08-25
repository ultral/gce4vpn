resource "google_project_service" "bigqueryjson" {
  service = "bigquery-json.googleapis.com"
}

resource "google_project_service" "storageapi" {
  service = "storage-api.googleapis.com"
}

resource "google_project_service" "storagecomponent" {
  service = "storage-component.googleapis.com"
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}


resource "google_project_service" "container" {
  service = "container.googleapis.com"
}

resource "google_project_service" "containerregistry" {
  service = "containerregistry.googleapis.com"
}

resource "google_project_service" "oslogin" {
  service = "oslogin.googleapis.com"
}

resource "google_project_service" "monitoring" {
  service = "monitoring.googleapis.com"
}
