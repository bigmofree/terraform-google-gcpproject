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
#  no need for this one , using anpther block of code
# resource “null_resource” “enable-apis” {
#   depends_on = [
#     google_project.testproject,
#     null_resource.set-project
#   ]
#   triggers = {
#     always_run = “${timestamp()}”
#   }
#   provisioner “local-exec” {
#     command = <<-EOT
#         gcloud services enable compute.googleapis.com
#         gcloud services enable dns.googleapis.com
#         gcloud services enable storage-api.googleapis.com
#         gcloud services enable container.googleapis.com
#         gcloud services enable file.googleapis.com
#     EOT
#   }
# }
# resource “google_project_service” “project1” resource.google_project_service.project1
# e {
# nable apis
resource “google_project_service” “project” {
  count = length(var.apis)
  # project = “your-project-id”
  service = var.apis[count.index]
  # timeouts {
  #   create = “30m”
  #   update = “40m”
  # }
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
