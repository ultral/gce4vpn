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

variable "openvpn_file_private_key" {
  description = "Path to your private.key file."
}

variable "openvpn_file_ca_crt" {
  description = "Path to your ca.crt file."
}

variable "openvpn_file_certificate_crt" {
  description = "Path to your certificate.crt file."
}

variable "openvpn_file_dh_pem" {
  description = "Path to your dh.pem file."
}

variable "openvpn_file_ta_key" {
  description = "Path to your ta.key file."
}

variable "service_cidr" {
  description = "gcloud container clusters describe gce4vpn-k8s --zone europe-north1-a| grep servicesIpv4Cidr"
}

variable "pod_cidr" {
  description = "gcloud container clusters describe gce4vpn-k8s --zone europe-north1-a| grep clusterIpv4Cidr"
}
