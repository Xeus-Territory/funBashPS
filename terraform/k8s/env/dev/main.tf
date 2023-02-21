module "ingress-controller" {
    source = "../../modules/ingress-controller"
}

module "applications" {
    source = "../../modules/applications"
    depends_on = [
      module.ingress-controller
    ]
}