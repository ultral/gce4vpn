variable "k8s_cluster_name" {
  type = "string"
  description = "Cluster name"
  default = "gce4vpn-k8s"
}

variable "k8s_nodes_count" {
  type = "string"
  description = "Count of nodes"
  default = 1
}

variable "k8s_admin_username" {
  type        = "string"
  description = "Admin login."
}

variable "k8s_admin_password" {
  type ="string"
  description = "Admin password."
}

variable "k8s_cluster_primary_zone" {
  type = "string"
  description = "Cluster primary zone name"
  default = "europe-north1-a"
}

variable "k8s_cluster_slave_zone1" {
  type = "string"
  description = "Cluster slave zone name"
  default = "europe-north1-b"
}

variable "k8s_cluster_slave_zone2" {
  type = "string"
  description = "Cluster slave zone name"
  default = "europe-north1-c"
}

variable "node_machine_type" {
  description = "GCE machine type"
  default = "n1-standard-2"
}

variable "node_disk_size" {
  type = "string"
  description = "Node disk size in GB"
  default = 20
}

variable "google_project_name" {
  type = "string"
  description = "Project name"
  default = "gce4vpn2"
}
