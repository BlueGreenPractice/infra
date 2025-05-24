variable "project" { type = string }
variable "region" { type = string }
variable "cluster_name" { type = string }
variable "network" { type = string }
variable "subnetwork" { type = string }
variable "node_locations" {
  description = "node locations"
  type        = list(string)
}