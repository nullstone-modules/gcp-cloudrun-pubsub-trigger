data "ns_connection" "topic" {
  name     = "topic"
  contract = "datastore/gcp/pubsub"
}

locals {
  topic_id   = data.ns_connection.topic.outputs.topic_id
  topic_name = data.ns_connection.topic.outputs.topic_name
}
