# Get the resource group for network resources
data "azurerm_resource_group" "current" {
  name = "DevOpsIntern"
}