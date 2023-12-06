# output the GCP cloud function url
# curl https://<region>-<project-id>.cloudfunctions.net/terraform-function to check if the GCP function works as expected.
output "function_url" {
  value = google_cloudfunctions_function.function.https_trigger_url
}