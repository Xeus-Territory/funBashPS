# Create Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-network"
  address_space       = var.address_space
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags = var.tags
}

# Create a Subnet
resource "azurerm_subnet" "cluster" {
  name                 = "${var.environment}-subnet-cluster"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.address_prefixes
  service_endpoints    = var.service_endpoints
}