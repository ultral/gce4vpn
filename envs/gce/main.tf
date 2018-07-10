module "k8s" {
  source = "../../modules/k8s"
}

module "echo" {
  source = "../../modules/echo"
}
