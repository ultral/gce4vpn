variable "k8s_cluster_name" {
  description = "K8s cluster name."
  default     = "gce4vpn-k8s"
}

variable "k8s_nodes_count" {
  description = "Count of k8s nodes."
  default     = 1
}

variable "k8s_admin_username" {
  description = "Admin login."
}

variable "k8s_admin_password" {
  description = "Admin password."
}

variable "gce_region" {
  description = "Cluster region name."
  default     = "europe-north1"
}

variable "k8s_node_machine_type" {
  description = "GCE machine type"
  default     = "n1-standard-2"
}

variable "k8s_node_disk_size" {
  description = "Node disk size in GB."
  default     = 20
}

variable "tfstate_region" {
  description = "Region for terraform state."
}

variable "tfstate_bucket" {
  description = "Bucket for terraform state."
}
