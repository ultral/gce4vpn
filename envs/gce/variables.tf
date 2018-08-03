variable "k8s_admin_username" {
  description = "K8s admin username."
}

variable "k8s_admin_password" {
  description = "K8s admin password."
}

variable "project" {
  description = "Project name in google cloud."
}

variable "openvpn_cn" {
  description = "Your vpn server domain name."
}

variable "openvpn_files" {
  description = "Path to your openvpn config files directory."
}

variable "k8s_pod_cidr" {
  description = "gcloud container clusters describe gce4vpn-k8s --zone europe-north1-a| grep clusterIpv4Cidr"
}

variable "k8s_service_cidr" {
  description = "Service CIDR."
}

variable "gce_region" {
  description = "Cluster region name."
  default = "europe-north1"
}
