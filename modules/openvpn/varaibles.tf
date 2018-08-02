variable "k8s_admin_username" {
  description = "Admin login."
}

variable "k8s_admin_password" {
  description = "Admin password."
}

variable "k8s_admin_url" {
  description = "K8s Admin url."
}

variable "k8s_client_cert" {
  description = "K8s client cert."
}

variable "k8s_client_key" {
  description = "K8s client key."
}

variable "k8s_cluster_ca_certificate" {
  description = "K8s cluster CA cert."
}

variable "openvpn_private_key" {
  description = "Base64 private.key."
}

variable "openvpn_ca_crt" {
  description = "Base64 ca.crt."
}

variable "openvpn_certificate_crt" {
  description = "Base64 certificate.crt."
}

variable "openvpn_dh_pem" {
  description = "Base64 dh.pem."
}

variable "openvpn_ta_key" {
  description = "Base64 ta.key."
}

variable "k8s_service_cidr" {
  description = "Service CIDR."
}

variable "k8s_pod_cidr" {
  description = "Pod CIDR."
}

variable "openvpn_server_url" {
  description = "Server URL."
}
