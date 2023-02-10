data "azurerm_virtual_network" "main" {
    name = "${var.environment}-network"
    resource_group_name = var.resource_group_name
}

# Get the datasource for the bucket
data "azurerm_subnet" "main" {
    name = "${var.environment}-subnet"
    virtual_network_name = data.azurerm_virtual_network.main.name
    resource_group_name = var.resource_group_name
}
