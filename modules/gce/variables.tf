variable "project" {
  description = "Project name in google cloud."
}

variable "region" {
  description = "Project region in google cloud."
}

variable "prefix" {
  default = "openvpn"
}

variable "ip_range" {
  description = "IP range in CIDR notation for k8s services."
}
