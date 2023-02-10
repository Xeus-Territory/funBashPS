data "azurerm_resource_group" "main"{
  name = var.resource_group_root
}

# Get data_resource from sshkey
data "azurerm_ssh_public_key" "main" {
  name = "DevOpsIntern"
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_container_registry" "main" {
  name                = "devopsorient"
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_virtual_network" "main" {
    name = "${var.environment}-network"
    resource_group_name = var.resource_group_name
}

# Get the datasource for the bucket
data "azurerm_subnet" "main" {
    name = "${var.environment}-subnet"
    virtual_network_name = data.azurerm_virtual_network.main.name
    resource_group_name = var.resource_group_name
}

data "azurerm_user_assigned_identity" "main" {
  name = "${var.environment}-identity"
  resource_group_name = var.resource_group_name
}


data "azurerm_lb" "main" {
  name                = "${var.environment}-loadbalancer"
  resource_group_name = var.resource_group_name
}

data "azurerm_lb_backend_address_pool" "main" {
  name                = "${var.environment}-lbBackendPool"
  loadbalancer_id     = data.azurerm_lb.main.id
}

data "azurerm_application_security_group" "main"{
  name                = "${var.environment}-asg-web"
  resource_group_name = var.resource_group_name
}

data "azurerm_storage_account" "main" {
  name                     = "${var.environment}orientdnintern"
  resource_group_name = var.resource_group_name
}

data "azurerm_storage_container" "main" {
  name                  = "${var.environment}-data"
  storage_account_name  = data.azurerm_storage_account.main.name
}

data "azurerm_storage_blob" "main" {
  name                   = "${var.environment}-blob-web"
  storage_account_name   = data.azurerm_storage_account.main.name
  storage_container_name = data.azurerm_storage_container.main.name
}
