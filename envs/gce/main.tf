module "k8s" {
  source = "../../modules/k8s"
  k8s_admin_username = "secret_login"
  k8s_admin_password = "secret_password"
}

module "echo" {
  source = "../../modules/echo"
}
