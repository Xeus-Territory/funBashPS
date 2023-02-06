data "azurerm_resource_group" "main" {
    name = var.resource_group_name
}

data "azurerm_ssh_public_key" "main" {
    name = var.public_key
    resource_group_name = data.azurerm_resource_group.main.name
}