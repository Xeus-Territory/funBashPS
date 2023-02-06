data "azurerm_resource_group" "main" {
    name = var.resource_group_name
}

data "azurerm_network_interface" "main" {
    name = var.nicAgent
    resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_user_assigned_identity" "main" {
    name = var.user_identity
    resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_ssh_public_key" "main" {
    name = var.public_key
    resource_group_name = data.azurerm_resource_group.main.name
}