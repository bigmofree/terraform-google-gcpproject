resource "google_compute_network" "global_vpc" {
    name = "Global-VPC"
        auto_create_subnetworks = "true"
        routing_mode = "GLOBAL"
}