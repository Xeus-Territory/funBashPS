# Create Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags = var.tags
}

# Create a Subnet
resource "azurerm_subnet" "main" {
  name                 = "${var.environment}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_subnet" "appsubnet" {
  name                 = "${var.environment}-app-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "ingress" {
  name                = "ingress-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                  = "Standard"
}

resource "azurerm_application_gateway" "network" {
  name                = "ingress-appgateway"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "ingress-gateway-ip-configuration"
    subnet_id = azurerm_subnet.appsubnet.id
  }

  frontend_port {
    name = "ingress_frontend_port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "ingress_frontend_pip"
    public_ip_address_id = azurerm_public_ip.ingress.id
  }

  backend_address_pool {
    name = "ingress_backend_pool"
  }

  backend_http_settings {
    name                  = "ingress_http_setting"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "ingress_http_listener"
    frontend_ip_configuration_name = "ingress_frontend_pip"
    frontend_port_name             = "ingress_frontend_port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "ingress_request_routing_rule"
    rule_type                  = "Basic"
    http_listener_name         = "ingress_http_listener"
    backend_address_pool_name  = "ingress_backend_pool"
    backend_http_settings_name = "ingress_http_setting"
}

  depends_on = [
    azurerm_virtual_network.main, azurerm_public_ip.ingress
  ]

}