# Create network
resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-network"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags = var.tag
}

# Create the subnet for VMSS
resource "azurerm_subnet" "main" {
  name                 = "${var.environment}-subnetAgent"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.address_prefixes_subnet
  service_endpoints = var.service_endpoints
}

# Create the network network security group
resource "azurerm_network_security_group" "main" {
  name                = "${var.environment}-nsgAgent"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags = var.tag
}

resource "azurerm_subnet_network_security_group_association" "main" {
    subnet_id = azurerm_subnet.main.id
    network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_network_interface" "main" {
    name = "${var.environment}-nicAgent"
    location = data.azurerm_resource_group.main.location
    resource_group_name = data.azurerm_resource_group.main.name

    ip_configuration {
      name = "${var.environment}-nicConfiguration"
      subnet_id = azurerm_subnet.main.id
      private_ip_address_allocation = var.private_ip_address_allocation
    }

    tags = var.tag
}

