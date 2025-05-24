variable "project_id" {

  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "ssh_key" {
  type        = string
  description = "usuario:ssh-rsa AAAA..."
}

variable "apps_machine_type" {
  type    = string
  default = "n1-standard-1"
}

variable "cicd_machine_type" {
  type    = string
  default = "n1-standard-1"
}

variable "credentials_file" {
  description = "value of the credentials file"
  type        = string
  default     = "terraform-key.json"
}

variable "node_locations" {
  description = "node locations"
  default     = ["us-central1-c"]
  type        = list(string)
}