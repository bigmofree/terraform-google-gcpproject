resource "google_compute_network" "global_vpc" {
    name = "global-vpc"
        auto_create_subnetworks = "true"
        routing_mode = "GLOBAL"
}