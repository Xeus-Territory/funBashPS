# Create network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "${local.environment}-network"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.current.location
  resource_group_name = data.azurerm_resource_group.current.name
  tags = local.common_tags
}

# Create the subnet
resource "azurerm_subnet" "my_terraform_network_subnet" {
  name                 = "${local.environment}-subnet"
  resource_group_name  = data.azurerm_resource_group.current.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints = [ "Microsoft.Storage" ]
}

resource "azurerm_application_security_group" "main" {
  name = "${local.environment}-asg"
  location = data.azurerm_resource_group.current.location
  resource_group_name = data.azurerm_resource_group.current.name
  tags = local.common_tags
}

# Create a SecurityGroup
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "${local.environment}-nsg"
  location            = data.azurerm_resource_group.current.location
  resource_group_name = data.azurerm_resource_group.current.name

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_application_security_group_ids = [ azurerm_application_security_group.main.id ]
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_application_security_group_ids = [ azurerm_application_security_group.main.id ]
  }

  tags = local.common_tags
}

# Create association via subnet with nsg
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id = azurerm_subnet.my_terraform_network_subnet.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

resource "azurerm_public_ip" "publicip_LB" {
  name = "${local.environment}-lbpublicIP"
  resource_group_name = data.azurerm_resource_group.current.name
  location = data.azurerm_resource_group.current.location
  allocation_method = "Static"
  sku = "Standard"
  tags = local.common_tags
}