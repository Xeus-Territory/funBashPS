resource "azurerm_subnet" "ingress" {
  name                 = "${var.environment}-subnet-ingress"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_public_ip" "ingress" {
  name                = "ingress-pip"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                  = "Standard"
}

resource "azurerm_application_gateway" "main" {
  name                = "ingress-appgateway"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "ingress-gateway-ip-configuration"
    subnet_id = azurerm_subnet.ingress.id
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
    priority = "100"
}

  depends_on = [
    azurerm_virtual_network.main, azurerm_public_ip.ingress
  ]
}