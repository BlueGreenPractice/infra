resource "google_compute_network" "vpc" {
  name                    = "devopsshack-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "devopsshack-subnet"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  ip_cidr_range            = "10.40.0.0/16" # rango principal para nodos
  private_ip_google_access = true

  ## rangos secundarios:
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.42.0.0/17"
  }
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.43.0.0/22"
  }
}

# ruta por defecto a Internet
resource "google_compute_route" "default_internet" {
  name             = "default-internet"
  network          = google_compute_network.vpc.name
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
}

# firewall: all egress, all ingress (igual que SG de ejemplo)
resource "google_compute_firewall" "allow-all" {
  name    = "devopsshack-allow-all"
  network = google_compute_network.vpc.name
  allow { protocol = "all" }
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}
resource "google_compute_firewall" "allow-all-egress" {
  name      = "devopsshack-allow-egress"
  network   = google_compute_network.vpc.name
  direction = "EGRESS"
  allow { protocol = "all" }
  destination_ranges = ["0.0.0.0/0"]
}
