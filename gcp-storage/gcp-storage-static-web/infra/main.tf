
# Bucket to store website
# For more info on the resource check the Terraform Resource provider doc page
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "website" {
    name     = var.bucket_name
    location = "US"
}

# Upload the HTML file to the bucket
# For more info on the resource check the Terraform Resource provider doc page
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object
resource "google_storage_bucket_object" "static_web_src" {
    name   = "index.html"
    source = "../website/index.html"
    bucket = google_storage_bucket.website.name
}

# Bucket access control set to open publicly
# For more info on the resource check the Terraform Resource provider doc page
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_access_control
resource "google_storage_object_access_control" "static_web_public_rule" {
    object = google_storage_bucket_object.static_web_src.name
    bucket = google_storage_bucket.website.name
    role   = "READER"
    entity = "allUsers"
}

