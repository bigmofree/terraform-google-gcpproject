resource "random_string" "random" {
  length  = 14
  special = false
  upper   = false
}



resource "google_storage_bucket" "default" {
    name = "bucket-terraform-${random_string.random.result}"
    location = "us-central1"
    storage_class = "REGIONAL"
    force_destroy = true
}
