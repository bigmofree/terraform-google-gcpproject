data "google_billing_account" "acct" {
  display_name = "My Billing Account"
  open         = true
}

resource "random_string" "string" {
  length  = 16
  numeric = false
  special = false
  lower   = true
  upper   = false
}


resource "google_project" "class4" {
  name            = "class4"
  project_id      = random_string.string.result
  billing_account = data.google_billing_account.acct.id
}


resource "null_resource" "set-project" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "gcloud config set project ${google_project.class4.project_id}"
  }
}