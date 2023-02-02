data "azurerm_resource_group" "main" {
    name = "DevOpsIntern"
}

data "azurerm_ssh_public_key" "main" {
    name = "DevOpsIntern"
    resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_managed_disk" "main" {
    name = "${local.environment}-disk"
    resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_virtual_network" "main" {
    name = "${local.environment}-network"
    resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_subnet" "main" {
    name = "${local.environment}-subnetVM"
    virtual_network_name = data.azurerm_virtual_network.main.name
    resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_application_security_group" "main" {
    name = "${local.environment}-asg"
    resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_user_assigned_identity" "identity" {
  name = "${local.environment}-identityforVM"
  resource_group_name = data.azurerm_resource_group.main.name
}