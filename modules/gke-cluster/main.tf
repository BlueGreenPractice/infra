resource "google_container_cluster" "gke" {
  name                     = var.cluster_name
  location                 = var.region
  network                  = var.network
  subnetwork               = var.subnetwork
  node_locations           = var.node_locations
  remove_default_node_pool = true
  initial_node_count       = 1


  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }


  deletion_protection = false

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
}
