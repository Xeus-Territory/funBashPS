data "azurerm_container_registry" "main" {
  name = "devopsorient"
  resource_group_name = "DevOpsIntern"
}

data "azurerm_resource_group" "main" {
  name = "dev-environment"
}
