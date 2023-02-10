# Move the azure for new resource
resource "azurerm_resource_group" "main" {
  name = var.resource_group_name
  location = var.resource_group_location
  tags = var.tags
}

module "iam" {
    source = "../modules/iam"
    resource_group_root_id = data.azurerm_resource_group.main.id
    resource_group_id = azurerm_resource_group.main.id
    resource_group_name = azurerm_resource_group.main.name
    resource_group_location = azurerm_resource_group.main.location
    environment = var.environment
    tags = var.tags
}

module "network" {
    source = "../modules/networking"
    resource_group_name = azurerm_resource_group.main.name
    resource_group_location = azurerm_resource_group.main.location
    environment = var.environment
    tags = var.tags
    depends_on = [
      module.iam
    ]
}

module "balancer" {
    source = "../modules/loadBalancer"
    resource_group_name = azurerm_resource_group.main.name
    resource_group_location = azurerm_resource_group.main.location    
    environment = var.environment
    tags = var.tags
    depends_on = [
      module.network
    ]
}

module "storage" {
    source = "../modules/storage"
    resource_group_name = azurerm_resource_group.main.name
    resource_group_location = azurerm_resource_group.main.location   
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
    resource_group_root = var.resource_group_root
    resource_group_name = azurerm_resource_group.main.name
    resource_group_location = azurerm_resource_group.main.location   
    environment = var.environment
    tags = var.tags
    depends_on = [
        module.storage
    ]
}