provider "google" {
  credentials = var.credentials_file
  project     = var.project_id
  region      = var.region

}

data "google_client_config" "default" {}


provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.cluster_ca)

}



provider "helm" {
  kubernetes = {
    host                   = module.gke.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.cluster_ca)
  }
}

# ── Módulo de red ───────────────────────────────────────────────
module "network" {
  source  = "./modules/network"
  project = var.project_id
  region  = var.region
  cidr    = "10.0.0.0/16"
}

# ── Módulo clúster ──────────────────────────────────────────────
module "gke" {
  source         = "./modules/gke-cluster"
  project        = var.project_id
  region         = var.region
  network        = module.network.network_name
  subnetwork     = module.network.subnet_name
  cluster_name   = "devopsshack"
  node_locations = var.node_locations
}

data "google_container_cluster" "gke" {
  name       = module.gke.cluster_name
  location   = var.region
  depends_on = [module.gke]
}

# ── Node-pool de aplicación (Blue, Green, DB) ──────────────────
module "apps_pool" {
  source       = "./modules/node-pool"
  cluster_name = module.gke.cluster_name
  location     = var.region
  node_count   = 3
  machine_type = var.apps_machine_type
  role_label   = "apps"
  ssh_key      = var.ssh_key
}

# ── Node-pool CICD (Jenkins, Nexus, Sonar) ─────────────────────
module "cicd_pool" {
  source       = "./modules/node-pool"
  cluster_name = module.gke.cluster_name
  location     = var.region
  node_count   = 3
  machine_type = var.cicd_machine_type
  role_label   = "cicd"
  ssh_key      = var.ssh_key
}

module "namespace" {
  source     = "./modules/namespace"
  depends_on = [module.apps_pool, module.cicd_pool]
}

module "nat" {
  source     = "./modules/nat"
  project_id = var.project_id
  region     = var.region
  network    = module.network.network_name
  depends_on = [module.network]
}

