resource "random_string" "random" {
  length  = 6
  special = false
}

resource "google_storage_bucket" "default" {
  name         = "bucket-terraform-${random_string.random.result}"
  location     = "US"
  force_destroy = true
}
