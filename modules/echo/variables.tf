variable "text_inside_test_container" {
  description = "text message."
  default     = "hello 123"
}

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
