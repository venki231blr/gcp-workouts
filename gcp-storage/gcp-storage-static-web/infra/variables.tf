# Name for the GCP storage bucket
variable "bucket_name" {
  # Change the default balue to whatever the GCP bucket storage unique name of your like.
  # for GCP bucket storage naming considerations, check out the GCP bucket storage site.
  default = "your_gcp_bucket_name"  
}
# GCP service account key used for Terraform
variable "gcp_svc_key" {}

# GCP project name used for Testing project
variable "gcp_project" {}

# GCP region used for Testing project
variable "gcp_region" {}