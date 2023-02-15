data "azurerm_resource_group" "root"{
    name = "DevOpsIntern"
}

data "azurerm_resource_group" "main" {
    name = var.resource_group_name
}

data "azurerm_role_definition" "main" {
    name = "Read Container"
    scope = data.azurerm_resource_group.root.id
}