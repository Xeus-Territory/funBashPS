# Get data_resource from RG
data "azurerm_resource_group" "main" {
  name = "DevOpsIntern"
}

# data "azurerm_image" "main" {
#   name                = "linux-docker"
#   resource_group_name = data.azurerm_resource_group.main.name
# }
