resource "google_eventarc_trigger" "this" {
  name            = local.resource_name
  location        = local.region
  labels          = local.labels
  service_account = google_service_account.trigger.email

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }

  transport {
    pubsub {
      topic = local.topic_id
    }
  }

  destination {
    workflow = google_workflows_workflow.this.id
  }
}

resource "google_workflows_workflow" "this" {
  name                = "${local.resource_name}-trigger"
  region              = local.region
  description         = "Triggered by Pub/Sub message via Eventarc; runs Cloud Run Job"
  service_account     = google_service_account.trigger.email
  deletion_protection = false

  source_contents = <<EOF
main:
  params: [event]
  steps:
    - init:
        assign:
          - project_id: $${sys.get_env("GOOGLE_CLOUD_PROJECT_ID")}
          - job_id: "${local.job_id}"
          # Pub/Sub event payload (CloudEvent style):
          # event.data.message.data = base64-encoded string
          # event.data.message.attributes = map of attributes
          - base64_data: $${event.data.message.data}
          - message_text: $${text.decode(base64.decode(base64_data))}
          - attributes_json: $${json.encode(event.data.message.attributes)}
    - log_message:
        call: sys.log
        args:
          data: $${"Received Pub/Sub message: " + message_text}
          severity: "INFO"
    - run_job:
        # Use Cloud Run Jobs API via Workflows connector
        call: googleapis.run.v2.projects.locations.jobs.run
        args:
          name: $${job_id}
          body:
            # Optional: pass bucket + object to job as env vars
            overrides:
              containerOverrides:
                env:
                  - name: PUBSUB_MESSAGE
                    value: $${message_text}
                  - name: PUBSUB_ATTRIBUTES
                    value: $${attributes_json}
        result: job_execution
    - done:
        return: $${job_execution}
EOF
}
