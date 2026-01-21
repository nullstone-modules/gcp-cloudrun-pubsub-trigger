# gcp-cloudrun-pubsub-trigger
Nullstone capability to trigger a Cloud Run Job from a Pub/Sub Topic

## How to use

After adding this capability, update your code to use `PUBSUB_MESSAGE` and `PUBSUB_ATTRIBUTES` environment variables.
- `PUBSUB_MESSAGE` contains the message payload that is Base64-encoded.
- `PUBSUB_ATTRIBUTES` contains the message attributes.

## How it works

This capability creates an Eventarc trigger that listens to a Pub/Sub topic.
When fired, the trigger executes a GCP Workflow that subsequently executes a Cloud Run Job.
