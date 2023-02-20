module "ingress-controller" {
    source = "../../modules/ingress-controller"
}

module "app1" {
    source = "../../modules/applications"
}