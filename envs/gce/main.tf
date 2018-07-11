module "k8s" {
  source = "../../modules/k8s"
  k8s_admin_username = "secret_login"
  k8s_admin_password = "secret_password"
}

module "echo" {
  source = "../../modules/echo"
  k8s_admin_username = "secret_login"
  k8s_admin_password = "secret_password"
  k8s_admin_url      = "${module.k8s.k8s_admin_url}"
  k8s_client_cert             = "${base64decode(module.k8s.client_certificate)}"
  k8s_client_key              = "${base64decode(module.k8s.client_key)}"
  k8s_cluster_ca_certificate  = "${base64decode(module.k8s.cluster_ca_certificate)}"
}
