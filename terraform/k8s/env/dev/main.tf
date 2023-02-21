module "ingress-controller" {
    source = "../../modules/ingress-controller"
    metadata-namespace = var.namespace_ingress
}

module "applications" {
    source = "../../modules/applications"
    metadata-namespace = var.namespace_deployment
    depends_on = [
      module.ingress-controller
    ]
}