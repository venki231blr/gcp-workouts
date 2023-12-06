# GCP provider

provider "google" {
  credentials  = file(var.gcp_svc_key) # check the variables.tf file
  project      = var.gcp_project # check the variables.tf file
  region       = var.gcp_region # check the variables.tf file
}

# GCP beta provider
provider "google-beta" {
  credentials  = file(var.gcp_svc_key) # check the variables.tf file
  project      = var.gcp_project # check the variables.tf file
  region       = var.gcp_region # check the variables.tf file
}