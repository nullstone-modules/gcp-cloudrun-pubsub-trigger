resource "google_service_account" "trigger" {
  account_id  = "pubsub-trigger-${random_string.resource_suffix.result}"
  description = "Service account for triggering ${local.block_name} from Pub/Sub Topic ${local.topic_name}"
}

resource "google_project_iam_member" "eventarc_invoker" {
  project = local.project_id
  role    = "roles/workflows.invoker"
  member  = "serviceAccount:${google_service_account.trigger.email}"
}

resource "google_project_iam_member" "workflows_job_exec" {
  project = local.project_id
  role    = "roles/run.jobsExecutor"
  member  = "serviceAccount:${google_service_account.trigger.email}"
}

resource "google_project_iam_member" "workflows_job_exec_overrides" {
  project = local.project_id
  role    = "roles/run.jobsExecutorWithOverrides"
  member  = "serviceAccount:${google_service_account.trigger.email}"
}

resource "google_project_iam_member" "workflows_run_viewer" {
  project = local.project_id
  role    = "roles/run.viewer"
  member  = "serviceAccount:${google_service_account.trigger.email}"
}

resource "google_project_iam_member" "workflows_run_invoker" {
  project = local.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.trigger.email}"
}
