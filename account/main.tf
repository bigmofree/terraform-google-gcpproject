data “google_billing_account” “acct” {
  display_name = “My Billing Account”
  open         = true
}
output “id” {
  value = data.google_billing_account.acct.id
}
output “name” {
  value = data.google_billing_account.acct.name
}
output “display_name” {
  value = data.google_billing_account.acct.display_name
}
resource “random_password” “password” {
  length  = 16
  numeric = false
  special = false
  lower   = true
  upper   = false
}
#  creates project
resource “google_project” “testproject” {
  name            = “testproject”
  project_id      = random_password.password.result
  billing_account = data.google_billing_account.acct.id
}
# shows project id
output “project_id” {
  value = google_project.testproject.id
}
#  sets default project id
resource “null_resource” “set-project” {
  triggers = {
    always_run = “${timestamp()}”
  }
  provisioner “local-exec” {
    command = “gcloud config set project ${google_project.testproject.project_id}”
  }
}

# enable apis
resource “google_project_service” “project” {
  count = length(var.apis)
}

# project = “your-project-id”
  service = var.apis[count.index]

  disable_dependent_services = true
    depends_on = [
    google_project.testproject,
    null_resource.set-project
  ]
}
variable “apis” {
  type = list(string)
default = [
         “compute.googleapis.com”,
         “dns.googleapis.com”,
         “storage-api.googleapis.com”,
         “container.googleapis.com”,
         “file.googleapis.com”
]
}
