resource "google_service_account" "trigger" {
  account_id  = "pubsub-trigger-${random_string.resource_suffix.result}"
  description = "Service account for triggering ${local.block_name} from Pub/Sub Topic ${local.topic_name}"
}

resource "google_project_iam_member" "eventarc_invoker" {
  project = local.project_id
  role    = "roles/workflows.invoker"
  member  = "serviceAccount:${google_service_account.trigger.email}"
}

resource "google_project_iam_member" "workflows_job_runner" {
  project = local.project_id
  role    = "roles/run.jobRunner"
  member  = "serviceAccount:${google_service_account.trigger.email}"
}
