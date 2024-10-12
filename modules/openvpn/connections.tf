provider "kubernetes" {
  host                   = var.k8s_admin_url
  username               = var.k8s_admin_username
  password               = var.k8s_admin_password
  client_certificate     = var.k8s_client_cert
  client_key             = var.k8s_client_key
  cluster_ca_certificate = var.k8s_cluster_ca_certificate
}
