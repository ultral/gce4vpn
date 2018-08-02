variable "google_primary_zone" {
  description = "Primary zone."
  default = "europe-north1-a"
}

variable "k8s_admin_username" {
  description = "K8s admin username."
}

variable "k8s_admin_password" {
  description = "K8s admin password."
}

variable "project" {
  description = "Project name in google cloud."
}

variable "openvpn_common_name" {
  description = "Your vpn server domain name."
}
