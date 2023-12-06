locals {
  project_id = var.proj_id # Change the value based on your GCP project id
  timestamp  = formatdate("YYMMDDhhmmss", timestamp())
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = "git-function" # refers to the git-function directory that holds the GCP cloud function
  output_path = "/tmp/git-function-${local.timestamp}.zip" # We need to zip the GCP cloud function to deploy using terraform
}

# Block for GCP storage bucket creation
# For more info on the resource check the Terraform Resource provider doc page
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "bucket" {
  name     = "${local.project_id}-functions"
  location = "US"
}

# Block for GCP storage bucket object creation
# For more info on the resource check the Terraform Resource provider doc page
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object
resource "google_storage_bucket_object" "archive" {
  name   = "terraform-function.zip#${data.archive_file.source.output_md5}"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.source.output_path
}

# Block for GCP cloud function creation
# For more info on the resource check the Terraform Resource provider doc page
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function
resource "google_cloudfunctions_function" "function" {
  name    = "terraform-function"
  runtime = "nodejs16"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "helloFromGit"
}

# Block for GCP cloud function iam policy creation
# For more info on the resource check the Terraform Resource provider doc page
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function_iam
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}