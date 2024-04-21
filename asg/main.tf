#Adding autoscaling group in a zone specified in the variables file using an instance group manager as a target


provider "google" {
  project = "your-project-id"
  region  = "us-central1"
}

resource "google_compute_autoscaler" "default" {
  name   = "my-autoscaler"
  zone   = "us-central1-f"
  target = google_compute_instance_group_manager.p-igm.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 60
  }
}

resource "google_compute_instance_template" "default" {
  name           = "my-instance-template"
  machine_type   = "e2-medium"
  can_ip_forward = false

  disk {
    source_image = data.google_compute_image.debian_9.id
  }

  network_interface {
    network = google_compute_network.global_vpc.name
  }

  metadata_startup_script = file("wordpress.sh")

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_instance_group_manager" "default" {
  name = "my-igm"
  zone = "us-central1-f"

  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }

  target_pools       = [google_compute_target_pool.default.id]
  base_instance_name = "autoscaler-sample"
}

data "google_compute_image" "debian_9" {
  family  = "debian-9"
  project = "debian-cloud"
}

resource "google_compute_target_pool" "default" {
  name = "my-target-pool"
}
