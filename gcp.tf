data "google_client_config" "this" {}

locals {
  region     = data.google_client_config.this.region
  zone       = data.google_client_config.this.zone
  project_id = data.google_client_config.this.project
}

resource "google_project_service" "workflows" {
  service                    = "workflows.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "eventarc" {
  service                    = "eventarc.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}
