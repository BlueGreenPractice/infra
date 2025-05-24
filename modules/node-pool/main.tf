resource "google_container_node_pool" "pool" {
  name     = "${var.role_label}-pool"
  cluster  = var.cluster_name
  location = var.location



  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    labels       = { role = var.role_label }
    disk_size_gb = 10
    metadata = {
      ssh-keys = "terraform:${var.ssh_key}"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
