# Get data_resource from RG
data "azurerm_resource_group" "main" {
  name = "DevOpsIntern"
}

data "azurerm_virtual_network" "main" {
    name = "${var.environment}-network"
    resource_group_name = data.azurerm_resource_group.main.name
}

# Get the datasource for the bucket
data "azurerm_subnet" "main" {
    name = "${var.environment}-subnet"
    virtual_network_name = data.azurerm_virtual_network.main.name
    resource_group_name = data.azurerm_resource_group.main.name
}
