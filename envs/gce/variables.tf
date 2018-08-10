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

variable "gce_region" {
  description = "Cluster region name."
  default = "europe-north1"
}

variable "openvpn_publish_port" {
  description = "Openvpn port."
  default = 443
}
