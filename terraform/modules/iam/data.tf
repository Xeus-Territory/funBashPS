# Get datasource from the current rg
data "azurerm_resource_group" "current" {
    name = "DevOpsIntern"
}