# Get the information about the rg
data "azurerm_resource_group" "current_resource" {
  name = "DevOpsIntern"
}

data "azurerm_virtual_network" "current_virtual_network" {
    name = "${local.environment}-network"
    resource_group_name = data.azurerm_resource_group.current_resource.name
}

# Get the datasource for the bucket
data "azurerm_subnet" "current_subnet" {
    name = "${local.environment}-subnet"
    virtual_network_name = data.azurerm_virtual_network.current_virtual_network.name
    resource_group_name = data.azurerm_resource_group.current_resource.name
}
