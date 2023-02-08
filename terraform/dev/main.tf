module "iam" {
    source = "../modules/iam"
    environment = var.environment
    tags = var.tags
}

module "network" {
    source = "../modules/virtualNetwork"
    environment = var.environment
    tags = var.tags
    depends_on = [
      module.iam
    ]
}

module "balancer" {
    source = "../modules/loadBalancer"
    environment = var.environment
    tags = var.tags
    depends_on = [
      module.network
    ]
}

module "storage" {
    source = "../modules/storage"
    environment = var.environment
    tags = var.tags
    allowed_ips = var.allowed_ips
    blob_name = var.blob_name
    depends_on = [
      module.balancer
    ]
}


module "vmss" {
    source = "../modules/vmss"
    environment = var.environment
    tags = var.tags
    depends_on = [
        module.storage
    ]
}